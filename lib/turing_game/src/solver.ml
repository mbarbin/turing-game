open! Core

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

module Is_complete_result = struct
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
             let results = { Trace.Result.verifier = name; code; result } :: results in
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
                    if j <> j' then Some verifier else None)
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
