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

module Which_hypotheses : sig
  type t =
    | All
    | This of Decoder.Hypothesis.t
    | Only_the_first_n of { n : int }
end

(** This is used by tests to print the entire execution trace of what would
    happen if the given hypotheses were true. *)
val simulate_hypotheses : decoder:Decoder.t -> which_hypotheses:Which_hypotheses.t -> unit

val cmd : Command.t
