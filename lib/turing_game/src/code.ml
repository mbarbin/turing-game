open! Core

type t = Digit.t Symbol.Tuple.t [@@deriving compare, equal, hash, sexp_of]

let verifies t ~condition =
  match (condition : Condition.t) with
  | Equal { symbol; value } -> Digit.equal (Symbol.Tuple.get t symbol) value
  | Greater_than { a; b } -> Digit.to_int (Symbol.Tuple.get t a) > Digit.to_int b
  | Less_than { a; b } -> Digit.to_int (Symbol.Tuple.get t a) < Digit.to_int b
;;
