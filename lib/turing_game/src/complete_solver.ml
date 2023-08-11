open! Core

let debug = ref false

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

  let make_keys ~(resolution_path : Resolution_path.t) : Key.t array =
    Nonempty_list.concat_map resolution_path.rounds ~f:(fun { code; verifiers } ->
      Nonempty_list.map verifiers ~f:(fun verifier -> { Key.code; verifier }))
    |> Nonempty_list.to_array
  ;;

  let compute ~keys ~hypothesis =
    Array.map keys ~f:(fun { Key.code; verifier } ->
      Decoder.Hypothesis.verifies_exn hypothesis ~code ~verifier)
  ;;

  let by_keys ~keys ~decoder =
    List.map (Decoder.hypotheses decoder) ~f:(fun hypothesis ->
      let test_results = compute ~keys ~hypothesis in
      test_results, hypothesis)
  ;;
end

let test_results_by_hypothesis ~decoder ~resolution_path =
  let keys = Test_results.make_keys ~resolution_path in
  Test_results.by_keys ~keys ~decoder
;;

let max_number_of_remaining_codes ~decoder ~(resolution_path : Resolution_path.t) =
  test_results_by_hypothesis
    ~decoder
    ~resolution_path:(resolution_path : Resolution_path.t)
  |> Map.of_alist_fold
       (module Test_results)
       ~init:0
       ~f:(fun acc (_ : Decoder.Hypothesis.t) -> acc + 1)
  |> Map.fold ~init:0 ~f:(fun ~key:_ ~data acc -> Int.max data acc)
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
  let keys = Test_results.make_keys ~resolution_path in
  let test_results = Test_results.by_keys ~keys ~decoder in
  match
    test_results
    |> Map.of_alist_multi (module Test_results)
    |> Map.to_sequence
    |> Sequence.find ~f:(fun (_, hs) ->
      match hs with
      | [] | [ _ ] -> false
      | _ :: _ :: _ -> true)
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

let solve ~decoder ~visit_all_children =
  let verifiers = Decoder.verifiers decoder in
  let verifiers_groups =
    choose_n
      3
      (Nonempty_list.map verifiers ~f:(fun verifier -> verifier.name)
       |> Nonempty_list.to_list)
    |> List.map ~f:Nonempty_list.of_list_exn
  in
  let current_min_cost = ref None in
  let compare_with_current_min_cost ~cost =
    match !current_min_cost with
    | None -> Ordering.Less
    | Some current_min_cost ->
      Resolution_path.Cost.compare cost current_min_cost |> Ordering.of_int
  in
  let current_solutions = Queue.create () in
  let consider_solution ~cost ~resolution_path =
    match compare_with_current_min_cost ~cost with
    | Greater -> ()
    | Equal -> Queue.enqueue current_solutions resolution_path
    | Less ->
      Queue.clear current_solutions;
      Queue.enqueue current_solutions resolution_path;
      current_min_cost := Some cost
  in
  let rec visit_children ~(parent_path : Resolution_path.Round.t list) ~parent_evaluation =
    let to_visit =
      (let open List.Let_syntax in
       let%bind code = Codes.all |> Codes.to_list in
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
    (* We try with a tweak to the previous: only visiting the children that have
       the best evaluation. *)
    let to_visit =
      match visit_all_children with
      | true -> to_visit
      | false ->
        (match to_visit with
         | [] -> []
         | (best_evaluation, _) :: _ ->
           List.take_while to_visit ~f:(fun (evaluation, _) ->
             evaluation = best_evaluation))
    in
    if !debug
    then
      print_endline
        (Sexp.to_string_hum
           [%sexp
             { parent_path : Resolution_path.Round.t list
             ; current_min_cost : Resolution_path.Cost.t option ref
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
      match compare_with_current_min_cost ~cost with
      | Greater | Equal -> ()
      | Less ->
        visit_children
          ~parent_path:(resolution_path.rounds |> Nonempty_list.to_list)
          ~parent_evaluation:evaluation)
  in
  let parent_evaluation = Decoder.hypotheses decoder |> List.length in
  visit_children ~parent_path:[] ~parent_evaluation;
  Queue.to_list current_solutions
;;

let quick_solve ~decoder =
  with_return_option (fun { return } ->
    let verifiers = Decoder.verifiers decoder in
    let verifiers_groups =
      choose_n
        3
        (Nonempty_list.map verifiers ~f:(fun verifier -> verifier.name)
         |> Nonempty_list.to_list)
      |> List.map ~f:Nonempty_list.of_list_exn
    in
    let rec visit_children
      ~(parent_path : Resolution_path.Round.t list)
      ~parent_evaluation
      =
      let to_visit =
        (let open List.Let_syntax in
         let%bind code = Codes.all |> Codes.to_list in
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
      if !debug
      then
        print_endline
          (Sexp.to_string_hum
             [%sexp
               { parent_path : Resolution_path.Round.t list
               ; parent_evaluation : int
               ; number_of_children = (List.length to_visit : int)
               }]);
      List.iter to_visit ~f:(fun (evaluation, resolution_path) ->
        visit resolution_path ~evaluation)
    and visit resolution_path ~evaluation =
      if evaluation = 1
      then return resolution_path
      else
        visit_children
          ~parent_path:(resolution_path.rounds |> Nonempty_list.to_list)
          ~parent_evaluation:evaluation
    in
    let parent_evaluation = Decoder.hypotheses decoder |> List.length in
    visit_children ~parent_path:[] ~parent_evaluation)
;;

let simulate_resolution_path_for_hypothesis ~decoder ~hypothesis ~resolution_path =
  let keys = Test_results.make_keys ~resolution_path in
  let test_results = Test_results.compute ~keys ~hypothesis in
  let decoder =
    Array.fold2_exn
      keys
      test_results
      ~init:decoder
      ~f:(fun decoder { Test_results.Key.code; verifier } result ->
        let verifier = Decoder.verifier_exn decoder ~name:verifier in
        Decoder.add_test_result decoder ~code ~verifier ~result |> ok_exn)
  in
  let codes = Decoder.remaining_codes decoder in
  let expected_codes = Decoder.Hypothesis.remaining_codes hypothesis in
  if Codes.equal codes expected_codes
  then Ok codes
  else
    Or_error.error_s
      [%sexp "Unexpected remaining codes", { expected_codes : Codes.t; codes : Codes.t }]
;;

let simulate_resolution_path_for_all_hypotheses ~decoder ~resolution_path =
  List.map (Decoder.hypotheses decoder) ~f:(fun hypothesis ->
    simulate_resolution_path_for_hypothesis ~decoder ~hypothesis ~resolution_path
    |> (Or_error.ignore_m : Codes.t Or_error.t -> unit Or_error.t))
  |> Or_error.combine_errors_unit
;;
