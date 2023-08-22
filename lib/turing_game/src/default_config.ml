open! Core

let add ~index ~conditions = Config.add_verifier { index; conditions }

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
      (List.init 4 ~f:(fun count -> Condition.Has_digit_count { digit = Three; count })
       |> Nonempty_list.of_list_exn)
;;

let () =
  add
    ~index:10
    ~conditions:
      (List.init 4 ~f:(fun count -> Condition.Has_digit_count { digit = Four; count })
       |> Nonempty_list.of_list_exn)
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
      [ Is_smallest { symbol = Triangle }
      ; Is_smallest { symbol = Square }
      ; Is_smallest { symbol = Circle }
      ]
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
      [ Equal_value { symbol = Triangle; value = Four }
      ; Equal_value { symbol = Square; value = Four }
      ; Equal_value { symbol = Circle; value = Four }
      ]
;;

let () =
  add
    ~index:33
    ~conditions:
      [ Is_even { symbol = Triangle }
      ; Is_even { symbol = Square }
      ; Is_even { symbol = Circle }
      ]
;;

let () =
  add
    ~index:34
    ~conditions:
      [ Is_smallest_or_equally_smallest { symbol = Triangle }
      ; Is_smallest_or_equally_smallest { symbol = Square }
      ; Is_smallest_or_equally_smallest { symbol = Circle }
      ]
;;

let () =
  add
    ~index:40
    ~conditions:
      (Symbol.all
       |> Nonempty_list.of_list_exn
       |> Nonempty_list.concat_map ~f:(fun symbol ->
         Condition.
           [ Less_than_value { symbol; value = Three }
           ; Equal_value { symbol; value = Three }
           ; Greater_than_value { symbol; value = Three }
           ]))
;;
