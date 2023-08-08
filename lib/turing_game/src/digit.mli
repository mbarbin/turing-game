open! Core

(** In this game, digits that are used in codes can only have values 1 to 5. We
    make use of an enumerable type for it so we can more easily manipulate all
    codes in an exhaustive fashion. *)

type t =
  | One
  | Two
  | Three
  | Four
  | Five
[@@deriving compare, enumerate, equal, hash, sexp_of]

val to_int : t -> int
