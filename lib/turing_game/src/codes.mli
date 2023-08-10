open! Core

(** A representation for a set of codes. *)

type t [@@deriving equal, compare, sexp_of]

val empty : t
val all : t
val mem : t -> Code.t -> bool
val init : f:(Code.t -> bool) -> t
val to_list : t -> Code.t list
val concat : t list -> t
val verifies : t -> condition:Condition.t -> t
val filter : t -> f:(Code.t -> bool) -> t
val length : t -> int
