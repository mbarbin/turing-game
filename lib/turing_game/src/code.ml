open! Core

type t = Digit.t Symbol.Tuple.t [@@deriving compare, equal, hash, sexp_of]

let sexp_of_t { Symbol.Tuple.triangle; square; circle } =
  Sexp.Atom
    (sprintf "%d%d%d" (Digit.to_int triangle) (Digit.to_int square) (Digit.to_int circle))
;;
