open! Core

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
  let rec aux_round ~decoder ~results ~rounds =
    match (rounds : Resolution_path.Round.t list) with
    | [] ->
      if Option.is_some (Decoder.is_determined decoder)
      then Is_complete_result.Yes
      else
        Is_complete_result.No_with_counter_example
          { results = List.rev results; hypotheses = Decoder.hypotheses decoder }
    | { code; verifiers } :: rounds ->
      aux_verifier
        ~decoder
        ~results
        ~rounds
        ~code
        ~verifiers:(verifiers |> Nonempty_list.to_list)
  and aux_verifier ~decoder ~results ~rounds ~code ~verifiers =
    match verifiers with
    | [] -> aux_round ~decoder ~results ~rounds
    | name :: verifiers ->
      let verifier = Decoder.verifier_exn decoder ~name in
      let rec aux_all = function
        | [] -> Is_complete_result.Yes
        | result :: tl ->
          (match Decoder.add_test_result decoder ~verifier ~code ~result with
           | Ok decoder ->
             let results =
               { Is_complete_result.Trace.Result.verifier = name; code; result }
               :: results
             in
             (match aux_verifier ~decoder ~results ~rounds ~code ~verifiers with
              | Yes -> aux_all tl
              | No_with_counter_example _ as no -> no)
           | Error _ ->
             (* This result is impossible as per the information already available,
                so we shouldn't worry about whether we'll be determined in this
                case. *)
             aux_all tl)
      in
      aux_all [ true; false ]
  in
  aux_round ~decoder ~results:[] ~rounds:(resolution_path.rounds |> Nonempty_list.to_list)
;;

let is_complete_resolution_path ~decoder ~resolution_path =
  match is_complete_resolution_path_with_trace ~decoder ~resolution_path with
  | Yes -> true
  | No_with_counter_example _ -> false
;;

let max_number_of_remaining_codes ~decoder ~(resolution_path : Resolution_path.t) =
  let rec aux_round ~decoder ~rounds =
    match (rounds : Resolution_path.Round.t list) with
    | [] -> Decoder.hypotheses decoder |> List.length
    | { code; verifiers } :: rounds ->
      aux_verifier ~decoder ~rounds ~code ~verifiers:(verifiers |> Nonempty_list.to_list)
  and aux_verifier ~decoder ~rounds ~code ~verifiers =
    match verifiers with
    | [] -> aux_round ~decoder ~rounds
    | name :: verifiers ->
      let verifier = Decoder.verifier_exn decoder ~name in
      List.fold [ true; false ] ~init:1 ~f:(fun acc result ->
        match Decoder.add_test_result decoder ~verifier ~code ~result with
        | Ok decoder -> max acc (aux_verifier ~decoder ~rounds ~code ~verifiers)
        | Error _ ->
          (* This result is impossible as per the information already available,
             so this doesn't change the computed max. *)
          acc)
  in
  aux_round ~decoder ~rounds:(resolution_path.rounds |> Nonempty_list.to_list)
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

let add_verifier_to_resolution_path ~decoder ~resolution_path ~verifier =
  let evaluation_1 = max_number_of_remaining_codes ~decoder ~resolution_path in
  let resolution_path_2 =
    let last_round_index = Resolution_path.number_of_rounds resolution_path - 1 in
    { Resolution_path.rounds =
        Nonempty_list.mapi resolution_path.rounds ~f:(fun i round ->
          if i <> last_round_index
          then round
          else (
            match Resolution_path.Round.add_verifier round ~name:verifier with
            | None -> round
            | Some round -> round))
    }
  in
  if Resolution_path.equal resolution_path resolution_path_2
  then None
  else (
    let evaluation_2 =
      max_number_of_remaining_codes ~decoder ~resolution_path:resolution_path_2
    in
    Option.some_if (evaluation_2 < evaluation_1) resolution_path_2)
;;

let add_round_to_resolution_path ~decoder ~resolution_path ~code ~verifier =
  let evaluation_1 = max_number_of_remaining_codes ~decoder ~resolution_path in
  match Resolution_path.add_round resolution_path ~code ~verifier with
  | None -> None
  | Some resolution_path_2 ->
    let evaluation_2 =
      max_number_of_remaining_codes ~decoder ~resolution_path:resolution_path_2
    in
    Option.some_if (evaluation_2 < evaluation_1) resolution_path_2
;;

(* A note on the algorithm in use below.

   We go over trees of resolution paths that are expanded systematically, until
   we reach a path that is complete. When we do, we shrink it, and add the
   resulting shrunk paths into consideration. *)
let solve ~decoder =
  let verifiers = Decoder.verifiers decoder in
  let current_min_cost = ref Resolution_path.Cost.max_value in
  let current_solutions = Queue.create () in
  let consider_solution resolution_path =
    let cost = Resolution_path.cost resolution_path in
    match Resolution_path.Cost.compare cost !current_min_cost |> Ordering.of_int with
    | Greater -> ()
    | Equal -> Queue.enqueue current_solutions resolution_path
    | Less ->
      Queue.clear current_solutions;
      Queue.enqueue current_solutions resolution_path;
      current_min_cost := cost
  in
  let to_visit = Deque.create () in
  let visit ~where resolution_path =
    let cost = Resolution_path.cost resolution_path in
    match Resolution_path.Cost.compare cost !current_min_cost |> Ordering.of_int with
    | Greater -> ()
    | Equal | Less -> Deque.enqueue to_visit where resolution_path
  in
  List.iter (Codes.all |> Codes.to_list) ~f:(fun code ->
    Nonempty_list.iter verifiers ~f:(fun verifier ->
      visit
        ~where:`back
        { Resolution_path.rounds =
            [ { Resolution_path.Round.code
              ; verifiers =
                  Nonempty_list.filter_map verifiers ~f:(fun v ->
                    let name = v.name in
                    Option.some_if (not (Verifier.Name.equal name verifier.name)) name)
                  |> Nonempty_list.of_list_exn
              }
            ]
        }));
  while not (Deque.is_empty to_visit) do
    let resolution_path = Deque.dequeue_front_exn to_visit in
    print_endline
      (Sexp.to_string_hum
         [%sexp
           { visiting_path = (resolution_path : Resolution_path.t)
           ; current_min_cost : Resolution_path.Cost.t ref
           }]);
    if is_complete_resolution_path ~decoder ~resolution_path
    then (
      let shrunk = shrink_resolution_path ~decoder ~resolution_path in
      List.iter shrunk ~f:consider_solution)
    else (
      let cost = Resolution_path.cost resolution_path in
      match Resolution_path.Cost.compare cost !current_min_cost |> Ordering.of_int with
      | Greater -> ()
      | Equal | Less ->
        (*
           {v
        Nonempty_list.iter verifiers ~f:(fun verifier ->
          Option.iter
            (add_verifier_to_resolution_path
               ~decoder
               ~resolution_path
               ~verifier:verifier.name)
            ~f:(fun resolution_path -> visit resolution_path ~where:`front));
           v}
        *)
        List.iter (Codes.all |> Codes.to_list) ~f:(fun code ->
          if Nonempty_list.exists resolution_path.rounds ~f:(fun round ->
               Code.equal code round.code)
             |> not
          then
            Nonempty_list.iter verifiers ~f:(fun verifier ->
              visit
                ~where:`front
                { Resolution_path.rounds =
                    Nonempty_list.append
                      resolution_path.rounds
                      [ { Resolution_path.Round.code
                        ; verifiers =
                            Nonempty_list.filter_map verifiers ~f:(fun v ->
                              let name = v.name in
                              Option.some_if
                                (not (Verifier.Name.equal name verifier.name))
                                name)
                            |> Nonempty_list.of_list_exn
                        }
                      ]
                })))
    (*
       {v
          Nonempty_list.iter verifiers ~f:(fun verifier ->
            Option.iter
              (add_round_to_resolution_path
                 ~decoder
                 ~resolution_path
                 ~code
                 ~verifier:verifier.name)
              ~f:(fun resolution_path -> visit resolution_path ~where:`front))
       v}
    *)
  done;
  Queue.to_list current_solutions
;;
