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

(** More precisely than the binary criteria [complete/incomplete] one can
    compute the distribution of maximum remaining codes for a given resolution
    path, when going through all possible combination of verifiers conditions.
    This is useful to sort resolution path and choose thus that offer the best
    chance of getting more information in return. *)
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

(** Given a resolution path, add a verifier in the current round, if it results
    into a path that lead to a strictly reduced number of remaining codes. *)
val add_verifier_to_resolution_path
  :  decoder:Decoder.t
  -> resolution_path:Resolution_path.t
  -> verifier:Verifier.Name.t
  -> Resolution_path.t option

(** Given a resolution path, add a round if it results into a path that lead to
    a strictly reduced number of remaining codes. *)
val add_round_to_resolution_path
  :  decoder:Decoder.t
  -> resolution_path:Resolution_path.t
  -> code:Code.t
  -> verifier:Verifier.Name.t
  -> Resolution_path.t option

(** Proposes a few resolution path to solve the given decoder, among which that
    have the lowest cost. *)
val solve : decoder:Decoder.t -> Resolution_path.t list
