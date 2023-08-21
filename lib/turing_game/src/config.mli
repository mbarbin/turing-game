open! Core

module Game : sig
  type t =
    { name : string
    ; verifiers : int Nonempty_list.t
    }
  [@@deriving sexp_of]
end

type t =
  { verifiers : Verifier.t list
  ; games : Game.t list
  }
[@@deriving sexp_of]

(** Load the config installed in the system *)
val load_exn : unit -> t
