open! Core

let is_complete_resolution_path ~decoder ~(resolution_path : Resolution_path.t) =
  let rec aux_round ~decoder ~rounds =
    match (rounds : Resolution_path.Round.t list) with
    | [] -> Option.is_some (Decoder.is_determined decoder)
    | { code; verifiers } :: rounds ->
      aux_verifier ~decoder ~rounds ~code ~verifiers:(verifiers |> Nonempty_list.to_list)
  and aux_verifier ~decoder ~rounds ~code ~verifiers =
    match verifiers with
    | [] -> aux_round ~decoder ~rounds
    | verifier :: verifiers ->
      let verifier = Decoder.verifier_exn decoder ~name:verifier in
      List.for_all [ false; true ] ~f:(fun result ->
        match Decoder.add_test_result decoder ~verifier ~code ~result with
        | Ok decoder -> aux_verifier ~decoder ~rounds ~code ~verifiers
        | Error _ ->
          (* This result is impossible as per the information already available,
             so we shouldn't worry about whether we'll be determined in this
             case. *)
          true)
  in
  aux_round ~decoder ~rounds:(resolution_path.rounds |> Nonempty_list.to_list)
;;

let shrink_resolution_path ~decoder:_ ~resolution_path:_ = []
