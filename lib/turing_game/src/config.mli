(*_********************************************************************************)
(*_  turing-game - A bot that can play a board game called Turing Machine         *)
(*_  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

type t

(** Load the config installed in the system *)
val load_exn : unit -> t

val find_verifier_exn : t -> index:int -> Verifier.t
val decoder_exn : t -> int Nonempty_list.t -> Decoder.t

(** Register API *)

val add_verifier : Verifier.t -> unit
