open! Core

type t =
  { index : int
  ; conditions : Condition.t Nonempty_list.t
  }
[@@deriving compare, equal, sexp]
