open! Core

module Is_complete_result : sig
  module Trace : sig
    module Result : sig
      type t =
        { code : Code.t
        ; verifier : Verifier.Name.t
        ; result : bool
        }
      [@@deriving sexp_of]
    end

    type t =
      { results : Result.t list
      ; hypotheses : Decoder.Hypothesis.t list
      }
    [@@deriving sexp_of]
  end

  type t =
    | Yes
    | No_with_counter_example of Trace.t
  [@@deriving sexp_of]
end

(** A resolution_path is said to be complete if it forces the resolution down to
    a single remaining hypothesis, no matter what results all the tests that
    are selected are going to be. *)
val is_complete_resolution_path_with_trace
  :  decoder:Decoder.t
  -> resolution_path:Resolution_path.t
  -> Is_complete_result.t

val is_complete_resolution_path
  :  decoder:Decoder.t
  -> resolution_path:Resolution_path.t
  -> bool

(** Simulate the execution of a resolution path, assuming a particular
    hypothesis. This verifies that the remaining codes at the end of the execution
    match the value that was projected by the hypothesis. *)
val simulate_resolution_path_for_hypothesis
  :  decoder:Decoder.t
  -> hypothesis:Decoder.Hypothesis.t
  -> resolution_path:Resolution_path.t
  -> Codes.t Or_error.t

(** Simulate the execution of a resolution path for all hypotheses, and return
    a combined error if some simulation fail. *)
val simulate_resolution_path_for_all_hypotheses
  :  decoder:Decoder.t
  -> resolution_path:Resolution_path.t
  -> unit Or_error.t

(** More precisely than the binary criteria [complete/incomplete] one can
    compute the distribution of maximum remaining codes for a given resolution
    path, when going through all possible combination of verifiers conditions.
    This is useful to sort resolution path and choose the ones that offer the
    best chance of getting more information in return. *)
val max_number_of_remaining_codes
  :  decoder:Decoder.t
  -> resolution_path:Resolution_path.t
  -> int

(** Find and return all strict subpath of a given resolution path that are
    complete, if any exists. The returned resolution paths verify the added
    condition that they may not be further shrunk (they are minimal). *)
val shrink_resolution_path
  :  decoder:Decoder.t
  -> resolution_path:Resolution_path.t
  -> Resolution_path.t list

(** Proposes a few resolution path to solve the given decoder, among which that
    have the lowest cost. *)
val solve : decoder:Decoder.t -> visit_all_children:bool -> Resolution_path.t list

(** Return a single resolution path to solve the problem. The solution is not
    guaranteed to be optimal, but the hope is that it should be close to an
    optimal solution. *)
val quick_solve : decoder:Decoder.t -> Resolution_path.t option

(** Turn on to add debug prints during resolution. *)
val debug : bool ref
