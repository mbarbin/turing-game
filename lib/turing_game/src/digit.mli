open! Core

(** In this game, digits that are used in codes can only have values 1 to 5. We
    make use of an enumerable type for it so we can more easily manipulate all
    codes in an exhaustive fashion. *)

type t =
  | One
  | Two
  | Three
  | Four
  | Five
[@@deriving compare, enumerate, equal, hash, sexp]

val to_int : t -> int

module Tuple : sig
    type digit

    type 'a t =
      { one : 'a
      ; two : 'a
      ; three : 'a
      ; four : 'a
      ; five : 'a
      }
    [@@deriving compare, enumerate, equal, fields, hash, sexp_of]

    val init : f:(digit -> 'a) -> 'a t
    val get : 'a t -> digit -> 'a

    include Container.S1 with type 'a t := 'a t
    include Applicative.S with type 'a t := 'a t
  end
  with type digit := t
