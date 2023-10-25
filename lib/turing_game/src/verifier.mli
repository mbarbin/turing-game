open! Base

type t =
  { index : int
  ; predicates : Predicate.t Nonempty_list.t
  }
[@@deriving compare, equal, sexp_of]
