open! Core

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

module Is_complete_result : sig
  type t =
    | Yes
    | No_with_counter_example of Trace.t
  [@@deriving sexp_of]
end

(** A resolution_path is said to be complete if it forces the resolution down to
    a single remaining hypothesis. *)
val is_complete_resolution_path_with_trace
  :  decoder:Decoder.t
  -> resolution_path:Resolution_path.t
  -> Is_complete_result.t

val is_complete_resolution_path
  :  decoder:Decoder.t
  -> resolution_path:Resolution_path.t
  -> bool

(** Find and return all strict subpath of a given resolution path that are
    complete, if any exists. The returned resolution paths verify the added
    condition that they may not be further shrunk (they are minimal). *)
val shrink_resolution_path
  :  decoder:Decoder.t
  -> resolution_path:Resolution_path.t
  -> Resolution_path.t list
