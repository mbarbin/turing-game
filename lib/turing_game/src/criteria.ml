open! Base

type t =
  { index : int
  ; predicate : Predicate.t
  }
[@@deriving compare, equal, sexp_of]
