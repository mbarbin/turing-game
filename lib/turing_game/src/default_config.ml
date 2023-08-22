open! Core

let add ~index ~conditions = Config.add_verifier { index; conditions }
let symbols = Symbol.all |> Nonempty_list.of_list_exn
let orderings = Ordering.all |> Nonempty_list.of_list_exn

let () =
  add
    ~index:3
    ~conditions:
      (Nonempty_list.map orderings ~f:(fun ordering ->
         Condition.Compare_symbol_with_value { symbol = Square; ordering; value = Three }))
;;

let () =
  add
    ~index:4
    ~conditions:
      (Nonempty_list.map orderings ~f:(fun ordering ->
         Condition.Compare_symbol_with_value { symbol = Square; ordering; value = Four }))
;;

let () =
  add ~index:7 ~conditions:[ Is_even { symbol = Circle }; Is_odd { symbol = Circle } ]
;;

let () =
  add
    ~index:9
    ~conditions:
      (Nonempty_list.init 4 ~f:(fun count ->
         Condition.Has_digit_count { digit = Three; count }))
;;

let () =
  add
    ~index:10
    ~conditions:
      (Nonempty_list.init 4 ~f:(fun count ->
         Condition.Has_digit_count { digit = Four; count }))
;;

let () =
  add
    ~index:11
    ~conditions:
      (Nonempty_list.map orderings ~f:(fun ordering ->
         Condition.Compare_symbols { a = Triangle; ordering; b = Square }))
;;

let () =
  add
    ~index:14
    ~conditions:
      (Nonempty_list.map symbols ~f:(fun symbol ->
         Condition.Compare_symbol_with_others { symbol; orderings = [ Less ] }))
;;

let () =
  add
    ~index:22
    ~conditions:[ Are_increasing; Are_decreasing; Are_neither_increasing_nor_decreasing ]
;;

let () =
  add
    ~index:30
    ~conditions:
      (Nonempty_list.map symbols ~f:(fun symbol ->
         Condition.Compare_symbol_with_value { symbol; ordering = Equal; value = Four }))
;;

let () =
  add
    ~index:33
    ~conditions:
      (Nonempty_list.concat_map symbols ~f:(fun symbol ->
         Condition.[ Is_even { symbol }; Is_odd { symbol } ]))
;;

let () =
  add
    ~index:34
    ~conditions:
      (Nonempty_list.map symbols ~f:(fun symbol ->
         Condition.Compare_symbol_with_others { symbol; orderings = [ Less; Equal ] }))
;;

let () =
  add
    ~index:40
    ~conditions:
      (Nonempty_list.concat_map symbols ~f:(fun symbol ->
         Nonempty_list.map orderings ~f:(fun ordering ->
           Condition.Compare_symbol_with_value { symbol; ordering; value = Three })))
;;
