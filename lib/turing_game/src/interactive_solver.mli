open! Core

module Request_test : sig
  type t =
    { new_round : bool
    ; code : Code.t
    ; verifier : Verifier.Name.t
    ; info : Info.t
    }
  [@@deriving sexp_of]
end

module Step : sig
  (** The next step chosen by the interactive solver in its current state. *)
  type t =
    | Request_test of Request_test.t
    | Propose_solution of { code : Code.t }
        (** The solver believes it has reached the solution. *)
    | Error of Error.t
        (** The solver has reached an unexpected condition and cannot make progress. *)
    | Info of Info.t
        (** This is only returned by the simulation to insert useful information. *)
  [@@deriving sexp_of]
end

(** Return the next step chosen by the interactive solver, alongside some
    debugging info. *)
val next_step
  :  decoder:Decoder.t
  -> current_round:Resolution_path.Round.t option
  -> Step.t

(** This is used by tests to print the entire execution trace of what would
    happen if the given hypothesis was true. *)
val simulate_resolution_for_hypothesis
  :  decoder:Decoder.t
  -> hypothesis:Decoder.Hypothesis.t
  -> Step.t list
