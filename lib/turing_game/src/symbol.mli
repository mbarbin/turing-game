open! Core

(** There are 3 symbols in this game, each associated with a unique color. *)

type t =
  | Triangle
  | Square
  | Circle
[@@deriving compare, enumerate, equal, hash, sexp_of]

module Color : sig
  type t =
    | Blue
    | Yellow
    | Magenta
  [@@deriving compare, enumerate, equal, hash, sexp_of]
end

val color : t -> Color.t

module Triple : sig
  type 'a t =
    { triangle : 'a
    ; square : 'a
    ; circle : 'a
    }
  [@@deriving compare, enumerate, equal, fields, hash, sexp_of]

  include Container.S1 with type 'a t := 'a t
  include Applicative.S with type 'a t := 'a t
end

val colors : Color.t Triple.t
