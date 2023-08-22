open! Core

type t = Decoder.t

val v_02 : t

(** Generated online *)

val v_401 : t
val v_402 : t

(** All available problems as an alist. *)
val all : (int * t) list

(** Dynamically get the value of the given index. Raise if there are no decoder
    available with this index. *)
val get_exn : int -> t
