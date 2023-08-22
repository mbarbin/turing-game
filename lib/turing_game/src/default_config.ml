open! Core

let add ~index ~conditions = Config.add_verifier { index; conditions }
let symbols = Symbol.all |> Nonempty_list.of_list_exn

let () =
  add
    ~index:3
    ~conditions:
      [ Less_than_value { symbol = Square; value = Three }
      ; Equal_value { symbol = Square; value = Three }
      ; Greater_than_value { symbol = Square; value = Three }
      ]
;;

let () =
  add
    ~index:4
    ~conditions:
      [ Less_than_value { symbol = Square; value = Four }
      ; Equal_value { symbol = Square; value = Four }
      ; Greater_than_value { symbol = Square; value = Four }
      ]
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
      [ Less_than { a = Triangle; b = Square }
      ; Equal { a = Triangle; b = Square }
      ; Greater_than { a = Triangle; b = Square }
      ]
;;

let () =
  add
    ~index:14
    ~conditions:
      (Nonempty_list.map symbols ~f:(fun symbol -> Condition.Is_smallest { symbol }))
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
         Condition.Equal_value { symbol; value = Four }))
;;

let () =
  add
    ~index:33
    ~conditions:
      (Nonempty_list.map symbols ~f:(fun symbol -> Condition.Is_even { symbol }))
;;

let () =
  add
    ~index:34
    ~conditions:
      (Nonempty_list.map symbols ~f:(fun symbol ->
         Condition.Is_smallest_or_equally_smallest { symbol }))
;;

let () =
  add
    ~index:40
    ~conditions:
      (Nonempty_list.concat_map symbols ~f:(fun symbol ->
         Condition.
           [ Less_than_value { symbol; value = Three }
           ; Equal_value { symbol; value = Three }
           ; Greater_than_value { symbol; value = Three }
           ]))
;;
