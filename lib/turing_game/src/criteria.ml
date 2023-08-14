open! Core

type t =
  { index : int
  ; condition : Condition.t
  }
[@@deriving compare, equal, sexp_of]
