open! Core

(** A representation for a set of digits. *)

type t [@@deriving equal, compare, sexp_of]

val empty : t
val all : t
val mem : t -> Digit.t -> bool
val init : f:(Digit.t -> bool) -> t
