open! Core

module Name : sig
  type t = private string [@@deriving compare, equal, hash, sexp_of]
end

type t = private
  { name : Name.t
  ; criteria : Criteria.t Nonempty_list.t
  }
[@@deriving compare, equal, sexp_of]

val create : name:string -> conditions:Condition.t Nonempty_list.t -> t
