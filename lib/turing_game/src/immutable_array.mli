(*_********************************************************************************)
(*_  turing-game - A bot that can play a board game called Turing Machine         *)
(*_  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(** Handling arrays whose contents is never mutated. *)

type 'a t [@@deriving compare, equal, sexp_of]

val init : int -> f:(int -> 'a) -> 'a t
val of_array_mapi : 'a Array.t -> f:(int -> 'a -> 'b) -> 'b t
val length : _ t -> int
val find : 'a t -> f:('a -> bool) -> 'a option
val find_map : 'a t -> f:('a -> 'b option) -> 'b option
val to_list : 'a t -> 'a list
val iteri : 'a t -> f:(int -> 'a -> unit) -> unit
val mapi : 'a t -> f:(int -> 'a -> 'b) -> 'b t
val get : 'a t -> int -> 'a
val fold : 'a t -> init:'acc -> f:('acc -> 'a -> 'acc) -> 'acc
