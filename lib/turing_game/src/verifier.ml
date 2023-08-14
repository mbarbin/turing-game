open! Core

type t =
  { verifier_name : Verifier_name.t
  ; criteria : Criteria.t Nonempty_list.t
  }
[@@deriving compare, equal, sexp_of]

let create ~name ~conditions =
  let criteria =
    Nonempty_list.mapi conditions ~f:(fun index condition ->
      { Criteria.index; condition })
  in
  { verifier_name = Verifier_name.of_string name; criteria }
;;
