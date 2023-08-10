open! Core

type t [@@deriving sexp_of]

val create : verifiers:Verifier.t Nonempty_list.t -> t

(** Returns the verifiers used to create [t]. *)
val verifiers : t -> Verifier.t Nonempty_list.t

val verifier_exn : t -> name:Verifier.Name.t -> Verifier.t

(** Return the number of codes that are still possible given the information
    known by [t]. This is cached inside [t]. *)
val number_of_remaining_codes : t -> int

module Hypothesis : sig
  type t [@@deriving sexp_of]

  val verifier_exn : t -> name:Verifier.Name.t -> Condition.t
end

(** Returns all the hypothesis that can be made regarding the verifiers of [t],
    given all the information determined so far. [strict] is [true] by
    default, and restrict the hypotheses given to those that yield a unique
    solution. *)
val hypotheses : ?strict:bool -> t -> Hypothesis.t list

val is_determined : t -> Code.t option

(** During the course of the decoding, the decoder will request some tests to be
    run. Use this function to inform back [t] of the test result. *)
val add_test_result_exn : t -> verifier:Verifier.t -> code:Code.t -> result:bool -> t

val add_test_result
  :  t
  -> verifier:Verifier.t
  -> code:Code.t
  -> result:bool
  -> t Or_error.t
