open! Core

(** A resolution path is a sequence of tests that the bot requests to be run, in
    order to decipher the code. *)

module Round : sig
  (** During a given round, the code in use may not be changed. By the rules,
      it's also worth noting that there's a maximum number of 3 verifiers that can
      be interrogated per round. *)
  type t =
    { code : Code.t
    ; verifiers : Verifier.Name.t Nonempty_list.t
    }
  [@@deriving compare, equal, hash, sexp_of]

  val add_verifier : t -> name:Verifier.Name.t -> t option
end

type t = { rounds : Round.t Nonempty_list.t } [@@deriving compare, equal, hash, sexp_of]

(** The round is not rejected if the code was already used, and the verifier was
    either already used with this code, or if this code was already used
    before and the number of verifiers with it was not maxed out. *)
val add_round : t -> code:Code.t -> verifier:Verifier.Name.t -> t option

val number_of_rounds : t -> int

module Cost : sig
  type t =
    { number_of_rounds : int
    ; number_of_verifiers : int
    }
  [@@deriving compare, equal, hash, sexp_of]

  (** An upper bound that may serve to init some value. *)
  val max_value : t
end

val cost : t -> Cost.t

module Compare_by_cost : sig
  type nonrec t = t [@@deriving compare, equal, hash, sexp_of]
end
