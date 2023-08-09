open! Core

module Round = struct
  type t =
    { code : Code.t
    ; verifiers : Verifier.Name.t Nonempty_list.t
    }
  [@@deriving compare, equal, sexp_of]
end

type t = { rounds : Round.t Nonempty_list.t } [@@deriving compare, equal, sexp_of]

let number_of_rounds t = Nonempty_list.length t.rounds
