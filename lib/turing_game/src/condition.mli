open! Core

type t =
  | Const of bool
  | Equal_value of
      { symbol : Symbol.t
      ; value : Digit.t
      }
  | Greater_than_value of
      { symbol : Symbol.t
      ; value : Digit.t
      }
  | Less_than_value of
      { symbol : Symbol.t
      ; value : Digit.t
      }
  | Equal of
      { a : Symbol.t
      ; b : Symbol.t
      }
  | Greater_than of
      { a : Symbol.t
      ; b : Symbol.t
      }
  | Less_than of
      { a : Symbol.t
      ; b : Symbol.t
      }
  | Has_twins of bool
  | Has_triplets of bool
  | Has_no_triplets_no_twins
  | Less_even_than_odd_digits
  | More_even_than_odd_digits
  | Sum2_equal_value of
      { a : Symbol.t
      ; b : Symbol.t
      ; value : Digit.t
      }
  | Sum2_greater_than_value of
      { a : Symbol.t
      ; b : Symbol.t
      ; value : Digit.t
      }
  | Sum2_less_than_value of
      { a : Symbol.t
      ; b : Symbol.t
      ; value : Digit.t
      }
  | Is_odd of { symbol : Symbol.t }
  | Is_even of { symbol : Symbol.t }
  | Sum_is_even
  | Sum_is_odd
  | Has_digit_count of
      { digit : Digit.t
      ; count : int
      }
  | Is_smallest of { symbol : Symbol.t }
  | Is_smallest_or_equally_smallest of { symbol : Symbol.t }
  | Is_biggest of { symbol : Symbol.t }
  | Is_biggest_or_equally_biggest of { symbol : Symbol.t }
  | Has_odd_digits_count of { count : int }
  | Has_even_digits_count of { count : int }
  | Are_increasing
  | Are_decreasing
  | Are_neither_increasing_nor_decreasing
[@@deriving compare, equal, sexp_of]
