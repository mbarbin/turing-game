(*********************************************************************************)
(*  turing-game - A bot that can play a board game called Turing Machine         *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t = Digit.t Symbol.Tuple.t [@@deriving compare, equal, hash]

let to_string { Symbol.Tuple.triangle; square; circle } =
  Printf.sprintf
    "%d%d%d"
    (Digit.to_int triangle)
    (Digit.to_int square)
    (Digit.to_int circle)
;;

let sexp_of_t t = Sexp.Atom (to_string t)
