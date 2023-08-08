open! Core

type t = bool Digit.Tuple.t [@@deriving equal, compare, sexp_of]

let empty = Digit.Tuple.return false
let all = Digit.Tuple.return true
let mem t digit = Digit.Tuple.get t digit
let init ~f = Digit.Tuple.init ~f
