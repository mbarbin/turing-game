open! Core

type t =
  | Equal of
      { symbol : Symbol.t
      ; value : Digit.t
      }
  | Greater_than of
      { a : Symbol.t
      ; b : Digit.t
      }
  | Less_than of
      { a : Symbol.t
      ; b : Digit.t
      }
