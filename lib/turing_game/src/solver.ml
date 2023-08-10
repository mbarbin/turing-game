open! Core

module Test_results = struct
  module Key = struct
    type t =
      { code : Code.t
      ; verifier : Verifier.Name.t
      }
    [@@deriving compare, equal, hash, sexp_of]
  end

  module T = struct
    type t = bool array [@@deriving compare, equal, sexp_of]
  end

  include T
  include Comparator.Make (T)
end

let test_results_by_hypothesis ~decoder ~(resolution_path : Resolution_path.t) =
  let hypotheses = Decoder.hypotheses decoder in
  let keys =
    Nonempty_list.concat_map resolution_path.rounds ~f:(fun { code; verifiers } ->
      Nonempty_list.map verifiers ~f:(fun verifier -> { Test_results.Key.code; verifier }))
    |> Nonempty_list.to_array
  in
  List.map hypotheses ~f:(fun hypothesis ->
    let test_results =
      Array.map keys ~f:(fun { code; verifier } ->
        let condition = Decoder.Hypothesis.verifier_exn hypothesis ~name:verifier in
        Code.verifies code ~condition)
    in
    hypothesis, test_results)
;;

let max_number_of_remaining_codes ~decoder ~(resolution_path : Resolution_path.t) =
  let test_results =
    test_results_by_hypothesis
      ~decoder
      ~resolution_path:(resolution_path : Resolution_path.t)
  in
  List.map test_results ~f:(fun (_, test_results) -> test_results, 1)
  |> Map.of_alist_reduce (module Test_results) ~f:( + )
  |> Map.data
  |> List.reduce ~f:Int.max
  |> Option.value_exn ~here:[%here]
;;

module Is_complete_result = struct
  module Trace = struct
    module Result = struct
      type t =
        { code : Code.t
        ; verifier : Verifier.Name.t
        ; result : bool
        }
      [@@deriving sexp_of]
    end

    type t =
      { results : Result.t list
      ; hypotheses : Decoder.Hypothesis.t list
      }
    [@@deriving sexp_of]
  end

  type t =
    | Yes
    | No_with_counter_example of Trace.t
  [@@deriving sexp_of]
end

let is_complete_resolution_path_with_trace ~decoder ~(resolution_path : Resolution_path.t)
  =
  let hypotheses = Decoder.hypotheses decoder in
  let keys =
    Nonempty_list.concat_map resolution_path.rounds ~f:(fun { code; verifiers } ->
      Nonempty_list.map verifiers ~f:(fun verifier -> { Test_results.Key.code; verifier }))
    |> Nonempty_list.to_array
  in
  let test_results =
    List.map hypotheses ~f:(fun hypothesis ->
      let test_results =
        Array.map keys ~f:(fun { code; verifier } ->
          let condition = Decoder.Hypothesis.verifier_exn hypothesis ~name:verifier in
          Code.verifies code ~condition)
      in
      test_results, hypothesis)
  in
  match
    test_results
    |> Map.of_alist_multi (module Test_results)
    |> Map.to_alist
    |> List.find ~f:(fun (_, hs) -> List.length hs > 1)
  with
  | None -> Is_complete_result.Yes
  | Some (ts, hypotheses) ->
    let results =
      Array.map2_exn keys ts ~f:(fun { code; verifier } result ->
        { Is_complete_result.Trace.Result.code; verifier; result })
      |> Array.to_list
    in
    Is_complete_result.No_with_counter_example { results; hypotheses }
;;

let is_complete_resolution_path ~decoder ~resolution_path =
  match is_complete_resolution_path_with_trace ~decoder ~resolution_path with
  | Yes -> true
  | No_with_counter_example _ -> false
;;

let shrink_resolution_path ~decoder ~resolution_path =
  let visited = Hash_set.create (module Resolution_path) in
  let shrunk = Queue.create () in
  (* [aux_complete] is assumed to be called with a complete resolution_path. *)
  let rec aux_complete ~resolution_path =
    if not (Hash_set.mem visited resolution_path)
    then (
      Hash_set.add visited resolution_path;
      aux_complete_internal ~resolution_path)
  and aux_complete_internal
    ~resolution_path:({ Resolution_path.rounds } as resolution_path)
    =
    let to_visit = Queue.create () in
    Nonempty_list.iteri rounds ~f:(fun i { Resolution_path.Round.code = _; verifiers } ->
      Nonempty_list.iteri verifiers ~f:(fun j _ ->
        let rounds =
          Nonempty_list.filter_mapi
            rounds
            ~f:(fun i' ({ Resolution_path.Round.code; verifiers } as round) ->
              if i <> i'
              then Some round
              else (
                match
                  Nonempty_list.filter_mapi verifiers ~f:(fun j' verifier ->
                    Option.some_if (j <> j') verifier)
                with
                | [] -> None
                | hd :: tl -> Some { Resolution_path.Round.code; verifiers = hd :: tl }))
        in
        match rounds with
        | [] -> ()
        | hd :: tl ->
          let resolution_path = { Resolution_path.rounds = hd :: tl } in
          if is_complete_resolution_path ~decoder ~resolution_path
          then Queue.enqueue to_visit resolution_path));
    if Queue.is_empty to_visit then Queue.enqueue shrunk resolution_path;
    Queue.iter to_visit ~f:(fun resolution_path -> aux_complete ~resolution_path)
  in
  if is_complete_resolution_path ~decoder ~resolution_path
  then aux_complete ~resolution_path;
  Queue.to_list shrunk |> List.dedup_and_sort ~compare:Resolution_path.compare
;;

let rec choose_n n list =
  let length = List.length list in
  match compare n length |> Ordering.of_int with
  | Greater -> []
  | Equal -> [ list ]
  | Less ->
    (match list with
     | [] -> []
     | hd :: tl ->
       List.map (choose_n (n - 1) tl) ~f:(fun list -> hd :: list) @ choose_n n tl)
;;

(* A note on the algorithm in use below.

   We go over trees of resolution paths that are expanded systematically, until
   we reach a path that is complete. When we do, we shrink it, and add the
   resulting shrunk paths into consideration. *)
let solve ~decoder =
  let verifiers = Decoder.verifiers decoder in
  let verifiers_groups =
    choose_n
      3
      (Nonempty_list.map verifiers ~f:(fun verifier -> verifier.name)
       |> Nonempty_list.to_list)
    |> List.map ~f:Nonempty_list.of_list_exn
  in
  let current_min_cost = ref Resolution_path.Cost.max_value in
  let current_solutions = Queue.create () in
  let consider_solution ~cost ~resolution_path =
    match Resolution_path.Cost.compare cost !current_min_cost |> Ordering.of_int with
    | Greater -> ()
    | Equal -> Queue.enqueue current_solutions resolution_path
    | Less ->
      Queue.clear current_solutions;
      Queue.enqueue current_solutions resolution_path;
      current_min_cost := cost
  in
  let rec visit_children ~(parent_path : Resolution_path.Round.t list) ~parent_evaluation =
    let to_visit =
      (let open List.Let_syntax in
       let%bind code =
         List.filter (Codes.all |> Codes.to_list) ~f:(fun code ->
           List.exists parent_path ~f:(fun round -> Code.equal code round.code) |> not)
       in
       let%bind verifiers = verifiers_groups in
       return
         { Resolution_path.rounds =
             Nonempty_list.of_list_exn
               (parent_path @ [ { Resolution_path.Round.code; verifiers } ])
         })
      |> List.filter_map ~f:(fun resolution_path ->
        let evaluation = max_number_of_remaining_codes ~decoder ~resolution_path in
        Option.some_if (evaluation < parent_evaluation) (evaluation, resolution_path))
      |> List.sort ~compare:(fun (e1, _) (e2, _) -> Int.compare e1 e2)
    in
    print_endline
      (Sexp.to_string_hum
         [%sexp
           { parent_path : Resolution_path.Round.t list
           ; current_min_cost : Resolution_path.Cost.t ref
           ; parent_evaluation : int
           ; number_of_children = (List.length to_visit : int)
           }]);
    List.iter to_visit ~f:(fun (evaluation, resolution_path) ->
      visit resolution_path ~evaluation)
  and visit resolution_path ~evaluation =
    let cost = Resolution_path.cost resolution_path in
    if evaluation = 1
    then consider_solution ~cost ~resolution_path
    else (
      match Resolution_path.Cost.compare cost !current_min_cost |> Ordering.of_int with
      | Greater | Equal -> ()
      | Less ->
        visit_children
          ~parent_path:(resolution_path.rounds |> Nonempty_list.to_list)
          ~parent_evaluation:evaluation)
  in
  visit_children ~parent_path:[] ~parent_evaluation:Int.max_value;
  Queue.to_list current_solutions
;;
