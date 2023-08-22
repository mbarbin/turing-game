open! Core

type t = { verifiers : Verifier.t list } [@@deriving sexp_of]

let verifiers : Verifier.t list ref = ref []

let add_verifier (verifier : Verifier.t) =
  if not (List.exists !verifiers ~f:(fun v -> verifier.index = v.index))
  then verifiers := verifier :: !verifiers
;;

let load_exn () = { verifiers = List.rev !verifiers }

let find_verifier_exn t ~index =
  match List.find t.verifiers ~f:(fun verifier -> index = verifier.index) with
  | Some verifier -> verifier
  | None -> raise_s [%sexp "Verifier not found", { index : int }]
;;

let decoder_exn t verifiers =
  let verifiers =
    Nonempty_list.map verifiers ~f:(fun index -> find_verifier_exn t ~index)
  in
  Decoder.create ~verifiers
;;
