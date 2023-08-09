open! Core

module Name : sig
  type t = private string [@@deriving compare, equal, hash, sexp_of]
end

type t = private
  { name : Name.t
  ; conditions : Condition.t Nonempty_list.t
  }
[@@deriving compare, equal, sexp_of]

val create : name:string -> conditions:Condition.t Nonempty_list.t -> t

module Examples : sig
  val verifier_04 : t
  val verifier_09 : t
  val verifier_11 : t
  val verifier_14 : t
  val verifier_22 : t
  val verifier_30 : t
  val verifier_33 : t
  val verifier_34 : t
  val verifier_40 : t
end
