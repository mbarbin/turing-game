open! Core

type t = private
  { verifier_name : Verifier_name.t
  ; criteria : Criteria.t Nonempty_list.t
  }
[@@deriving compare, equal, sexp_of]

val create : name:string -> conditions:Condition.t Nonempty_list.t -> t
