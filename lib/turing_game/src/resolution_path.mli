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
end

type t = { rounds : Round.t Nonempty_list.t } [@@deriving compare, equal, hash, sexp_of]

val number_of_rounds : t -> int
