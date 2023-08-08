open! Core

type t [@@deriving sexp_of]

module Verifier : sig
  type t

  val create : Condition.t list -> t
end

val create : Verifier.t list -> t

module Hypothesis : sig
  type t [@@deriving sexp_of]

  module Short_sexp : sig
    type nonrec t = t [@@deriving sexp_of]
  end
end

val hypotheses : t -> Hypothesis.t list

(** During the course of the decoding, the decoder will request some tests to be
    run. Use this function to inform back [t] of the test result. *)
val add_test_result_exn : t -> verifier:Verifier.t -> code:Code.t -> result:bool -> unit
