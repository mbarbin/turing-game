open! Core

type t [@@deriving sexp_of]

module Verifier : sig
  type t [@@deriving sexp_of]

  val create : name:string -> conditions:Condition.t Nonempty_list.t -> t
end

val create : verifiers:Verifier.t Nonempty_list.t -> t

(** Returns the verifiers used to create [t]. *)
val verifiers : t -> Verifier.t Nonempty_list.t

module Hypothesis : sig
  type t [@@deriving sexp_of]
end

(** Returns all the hypothesis that can be made regarding the verifiers of [t],
    given all the information determined so far. [strict] is [true] by
    default, and restrict the hypotheses given to those that yield a unique
    solution. *)
val hypotheses : ?strict:bool -> t -> Hypothesis.t list

(** During the course of the decoding, the decoder will request some tests to be
    run. Use this function to inform back [t] of the test result. *)
val add_test_result_exn : t -> verifier:Verifier.t -> code:Code.t -> result:bool -> t
