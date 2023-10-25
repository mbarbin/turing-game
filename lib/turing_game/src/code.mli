open! Base

type t = Digit.t Symbol.Tuple.t [@@deriving compare, equal, hash, sexp_of]

val to_string : t -> string
