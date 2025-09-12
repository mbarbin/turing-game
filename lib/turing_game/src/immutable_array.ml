(*********************************************************************************)
(*  turing-game - A bot that can play a board game called Turing Machine         *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

include Array

let of_array_mapi a ~f = init (Array.length a) ~f:(fun index -> f index a.(index))
