(*_********************************************************************************)
(*_  turing-game - A bot that can play a board game called Turing Machine         *)
(*_  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

type t =
  | Const of bool
  | Compare_symbol_with_value of
      { symbol : Symbol.t
      ; ordering : Ordering.t
      ; value : Digit.t
      }
  | Compare_symbols of
      { a : Symbol.t
      ; ordering : Ordering.t
      ; b : Symbol.t
      }
  | Has_twins of bool
  | Has_triplets of bool
  | Has_no_triplets_no_twins
  | Less_even_than_odd_digits
  | More_even_than_odd_digits
  | Compare_sum_with_value of
      { symbols : Symbol.t list
      ; ordering : Ordering.t
      ; value : int
      }
  | Is_odd of { symbol : Symbol.t }
  | Is_even of { symbol : Symbol.t }
  | Sum_is_even
  | Sum_is_odd
  | Sum_is_multiple of { divider : int }
  | Has_digit_count of
      { digit : Digit.t
      ; count : int
      }
  | Compare_symbol_with_others of
      { symbol : Symbol.t
      ; orderings : Ordering.t list
      }
  | Has_odd_digits_count of { count : int }
  | Has_even_digits_count of { count : int }
  | Has_consecutive_decreasing_digits of { count : int }
  | Has_consecutive_increasing_digits of { count : int }
  | Are_increasing
  | Are_decreasing
  | Are_neither_increasing_nor_decreasing
[@@deriving compare, equal, sexp_of]

val evaluate : t -> code:Code.t -> bool
