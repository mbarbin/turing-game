type t [@@deriving sexp_of]

val create : verifiers:Verifier.t Nonempty_list.t -> t

(** Returns the verifiers used to create [t]. *)
val verifiers : t -> Verifier.t Nonempty_list.t

val verifier_exn : t -> verifier_index:int -> Verifier_info.t

(** Return the number of codes that are still possible given the information
    known by [t]. The expensive part of this computation is cached inside [t]. *)
val number_of_remaining_codes : t -> int

val remaining_codes : t -> Codes.t

module Hypothesis : sig
  type t [@@deriving sexp_of]

  val criteria_exn : t -> verifier_index:int -> Criteria.t

  (** Assuming the hypothesis [t], returns the expected result of the given
      test. Raises if [verifier] is unknown. *)
  val evaluate_exn : t -> code:Code.t -> verifier_index:int -> bool

  (** When the hypothesis is strict, it is guaranteed by construction to have a
      single remaining code. *)
  val remaining_code_exn : t -> Code.t

  val remaining_codes : t -> Codes.t
end

(** Returns all the hypothesis that can be made regarding the verifiers of [t],
    given all the information determined so far. [strict] is [true] by
    default, and restrict the hypotheses given to those that yield a unique
    solution. *)
val hypotheses : ?strict:bool -> t -> Hypothesis.t list

module Test_result : sig
  type nonrec t =
    | Ok of t
    | Inconsistency of Sexp.t
end

(** During the course of the decoding, the decoder will request some tests to be
    run. Use this function to inform back [t] of the test result. *)
val add_test_result
  :  t
  -> code:Code.t
  -> verifier_index:int
  -> result:bool
  -> Test_result.t

module Verifier_status : sig
  type t =
    | Undetermined of { remaining_criteria : Criteria.t Nonempty_list.t }
    | Determined of Criteria.t
  [@@deriving equal, sexp_of]
end

val verifier_status_exn : t -> verifier_index:int -> Verifier_status.t

module Criteria_and_probability : sig
  type t =
    { criteria : Criteria.t
    ; probability : float
    }
  [@@deriving equal, sexp_of]
end

val criteria_distribution_exn
  :  t
  -> verifier_index:int
  -> Criteria_and_probability.t Nonempty_list.t
