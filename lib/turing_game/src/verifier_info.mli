(*_********************************************************************************)
(*_  turing-game - A bot that can play a board game called Turing Machine         *)
(*_  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

type t =
  { verifier : Verifier.t
  ; verifier_letter : Verifier_letter.t
  }
[@@deriving compare, equal, sexp_of]
