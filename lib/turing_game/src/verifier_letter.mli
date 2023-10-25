open! Base

type t [@@deriving compare, equal, sexp_of]

val of_index : int -> t
val to_string : t -> string
