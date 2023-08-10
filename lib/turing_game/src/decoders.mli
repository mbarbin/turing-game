open! Core

type t = Decoder.t

val v_01 : t
val v_20 : t

(** Dynamically get the value of the given index. Raise if there are no decoder
    available with this index. *)
val get_exn : int -> t
