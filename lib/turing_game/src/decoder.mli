open! Core

type t [@@deriving sexp_of]

val create : verifiers:Verifier.t Nonempty_list.t -> t

(** Returns the verifiers used to create [t]. *)
val verifiers : t -> Verifier.t Nonempty_list.t

val verifier_exn : t -> name:Verifier.Name.t -> Verifier.t

(** Return the number of codes that are still possible given the information
    known by [t]. The expensive part of this computation is cached inside [t]. *)
val number_of_remaining_codes : t -> int

val remaining_codes : t -> Codes.t

module Test_results : sig
  module Key : sig
    type t =
      { code : Code.t
      ; verifier : Verifier.Name.t
      }
    [@@deriving compare, equal, hash, sexp_of]
  end

  type t = bool array [@@deriving compare, equal, sexp_of]

  include Comparator.S with type t := t
end

module Hypothesis : sig
  type t [@@deriving sexp_of]

  val verifier_exn : t -> name:Verifier.Name.t -> Condition.t
  val verifies_exn : t -> code:Code.t -> verifier:Verifier.Name.t -> bool

  (** When the hypothesis is strict, it is guaranteed by construction to have a
      single remaining code. *)
  val remaining_code_exn : t -> Code.t

  val remaining_codes : t -> Codes.t
  val compute_test_results : t -> keys:Test_results.Key.t array -> Test_results.t
end

(** Returns all the hypothesis that can be made regarding the verifiers of [t],
    given all the information determined so far. [strict] is [true] by
    default, and restrict the hypotheses given to those that yield a unique
    solution. *)
val hypotheses : ?strict:bool -> t -> Hypothesis.t list

val is_determined : t -> Code.t option

(** During the course of the decoding, the decoder will request some tests to be
    run. Use this function to inform back [t] of the test result. *)
val add_test_result
  :  t
  -> code:Code.t
  -> verifier:Verifier.t
  -> result:bool
  -> t Or_error.t

(** For each hypothesis, run the tests present in the keys and return their
    result. This function is meant to be used then to aggregate the results per
    test result, so as to compute the expected information gained for a given key. *)
val compute_test_results
  :  t
  -> keys:Test_results.Key.t array
  -> (Test_results.t * Hypothesis.t) list
