(*********************************************************************************)
(*  turing-game - A bot that can play a board game called Turing Machine         *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

module Code = Code
module Codes = Codes
module Predicate = Predicate
module Config = Config
module Criteria = Criteria
module Decoder = Decoder
module Digit = Digit
module Interactive_solver = Interactive_solver
module Resolution_path = Resolution_path
module Symbol = Symbol
module Verifier = Verifier

let main =
  Command.group
    ~summary:"A solver bot for the turing-game board game."
    [ "solver", Interactive_solver.cmd ]
;;
