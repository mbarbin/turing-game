open! Core

type t = Digit.t Symbol.Tuple.t [@@deriving compare, equal, hash, sexp_of]
