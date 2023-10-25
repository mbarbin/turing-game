open! Core

module Expected_information_gained : sig
  (** Evaluate a test in term of expected information bits gained. *)
  type t = private
    { bits_gained : float
    ; probability : float
    }
  [@@deriving sexp_of]

  val unreachable : t
  val compute : starting_number:int -> remaining_number:int -> probability:float -> t
end

module Evaluation : sig
  type t [@@deriving compare, sexp_of]

  val zero : t
  val is_zero : t -> bool
  val compute : Expected_information_gained.t Nonempty_list.t -> t Or_error.t
end

module Request_test : sig
  type t =
    { new_round : bool
    ; code : Code.t
    ; verifier_index : int
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

module Test_evaluation : sig
  type t =
    { evaluation : Evaluation.t
    ; score_if_true : Expected_information_gained.t
    ; score_if_false : Expected_information_gained.t
    ; info : Info.t
    }
  [@@deriving sexp_of]
end

val evaluate_test
  :  decoder:Decoder.t
  -> code:Code.t
  -> verifier:Verifier.t
  -> Test_evaluation.t Or_error.t
