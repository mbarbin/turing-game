open! Core

type t =
  | One
  | Two
  | Three
  | Four
  | Five
[@@deriving compare, enumerate, equal, hash, sexp_of]

let to_int = function
  | One -> 1
  | Two -> 2
  | Three -> 3
  | Four -> 4
  | Five -> 5
;;
