(*********************************************************************************)
(*  turing-game - A bot that can play a board game called Turing Machine         *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t = int [@@deriving compare, equal]

let of_index i = i

let to_string i =
  let c = Char.to_int 'A' + i |> Char.of_int_exn in
  String.make 1 c
;;

let sexp_of_t t = Sexp.Atom (to_string t)
