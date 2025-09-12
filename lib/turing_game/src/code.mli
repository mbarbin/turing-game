(*_********************************************************************************)
(*_  turing-game - A bot that can play a board game called Turing Machine         *)
(*_  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

type t = Digit.t Symbol.Tuple.t [@@deriving compare, equal, hash, sexp_of]

val to_string : t -> string
