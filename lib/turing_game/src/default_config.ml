(*********************************************************************************)
(*  turing-game - A bot that can play a board game called Turing Machine         *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let add index predicates = Config.add_verifier { index; predicates }
let symbols = Symbol.all |> Nonempty_list.of_list_exn
let orderings = Ordering.all |> Nonempty_list.of_list_exn

let () =
  add
    3
    (Nonempty_list.map orderings ~f:(fun ordering ->
       Predicate.Compare_symbol_with_value { symbol = Square; ordering; value = Three }))
;;

let () =
  add
    4
    (Nonempty_list.map orderings ~f:(fun ordering ->
       Predicate.Compare_symbol_with_value { symbol = Square; ordering; value = Four }))
;;

let () = add 7 [ Is_even { symbol = Circle }; Is_odd { symbol = Circle } ]

let () =
  add
    9
    (Nonempty_list.init 4 ~f:(fun count ->
       Predicate.Has_digit_count { digit = Three; count }))
;;

let () =
  add
    10
    (Nonempty_list.init 4 ~f:(fun count ->
       Predicate.Has_digit_count { digit = Four; count }))
;;

let () =
  add
    11
    (Nonempty_list.map orderings ~f:(fun ordering ->
       Predicate.Compare_symbols { a = Triangle; ordering; b = Square }))
;;

let () =
  add
    14
    (Nonempty_list.map symbols ~f:(fun symbol ->
       Predicate.Compare_symbol_with_others { symbol; orderings = [ Less ] }))
;;

let () = add 22 [ Are_increasing; Are_decreasing; Are_neither_increasing_nor_decreasing ]

let () =
  add
    30
    (Nonempty_list.map symbols ~f:(fun symbol ->
       Predicate.Compare_symbol_with_value { symbol; ordering = Equal; value = Four }))
;;

let () =
  add
    33
    (Nonempty_list.concat_map symbols ~f:(fun symbol ->
       Predicate.[ Is_even { symbol }; Is_odd { symbol } ]))
;;

let () =
  add
    34
    (Nonempty_list.map symbols ~f:(fun symbol ->
       Predicate.Compare_symbol_with_others { symbol; orderings = [ Less; Equal ] }))
;;

let () =
  add
    40
    (Nonempty_list.concat_map symbols ~f:(fun symbol ->
       Nonempty_list.map orderings ~f:(fun ordering ->
         Predicate.Compare_symbol_with_value { symbol; ordering; value = Three })))
;;
