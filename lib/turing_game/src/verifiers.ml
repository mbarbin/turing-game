open! Core

type t = Verifier.t

let create ~index ~conditions = { Verifier.index; conditions }

let v_03 =
  create
    ~index:3
    ~conditions:
      [ Less_than_value { symbol = Square; value = Three }
      ; Equal_value { symbol = Square; value = Three }
      ; Greater_than_value { symbol = Square; value = Three }
      ]
;;

let v_04 =
  create
    ~index:4
    ~conditions:
      [ Less_than_value { symbol = Square; value = Four }
      ; Equal_value { symbol = Square; value = Four }
      ; Greater_than_value { symbol = Square; value = Four }
      ]
;;

let v_05 =
  create
    ~index:5
    ~conditions:[ Is_even { symbol = Triangle }; Is_odd { symbol = Triangle } ]
;;

let v_07 =
  create ~index:7 ~conditions:[ Is_even { symbol = Circle }; Is_odd { symbol = Circle } ]
;;

let v_08 =
  create
    ~index:8
    ~conditions:
      (List.init 4 ~f:(fun count -> Condition.Has_digit_count { digit = One; count })
       |> Nonempty_list.of_list_exn)
;;

let v_09 =
  create
    ~index:9
    ~conditions:
      (List.init 4 ~f:(fun count -> Condition.Has_digit_count { digit = Three; count })
       |> Nonempty_list.of_list_exn)
;;

let v_10 =
  create
    ~index:10
    ~conditions:
      [ Has_digit_count { digit = Four; count = 0 }
      ; Has_digit_count { digit = Four; count = 1 }
      ; Has_digit_count { digit = Four; count = 2 }
      ; Has_digit_count { digit = Four; count = 3 }
      ]
;;

let v_11 =
  create
    ~index:11
    ~conditions:
      [ Less_than { a = Triangle; b = Square }
      ; Equal { a = Triangle; b = Square }
      ; Greater_than { a = Triangle; b = Square }
      ]
;;

let v_12 =
  create
    ~index:12
    ~conditions:
      [ Less_than { a = Triangle; b = Circle }
      ; Equal { a = Triangle; b = Circle }
      ; Greater_than { a = Triangle; b = Circle }
      ]
;;

let v_14 =
  create
    ~index:14
    ~conditions:
      [ Is_smallest { symbol = Triangle }
      ; Is_smallest { symbol = Square }
      ; Is_smallest { symbol = Circle }
      ]
;;

let v_18 = create ~index:18 ~conditions:[ Sum_is_odd; Sum_is_even ]

let v_19 =
  create
    ~index:19
    ~conditions:
      [ Sum2_less_than_value { a = Triangle; b = Square; value = 6 }
      ; Sum2_equal_value { a = Triangle; b = Square; value = 6 }
      ; Sum2_greater_than_value { a = Triangle; b = Square; value = 6 }
      ]
;;

let v_20 =
  create
    ~index:20
    ~conditions:[ Has_triplets true; Has_twins true; Has_no_triplets_no_twins ]
;;

let v_21 = create ~index:21 ~conditions:[ Has_twins false; Has_twins true ]

let v_22 =
  create
    ~index:22
    ~conditions:[ Are_increasing; Are_decreasing; Are_neither_increasing_nor_decreasing ]
;;

let v_30 =
  create
    ~index:30
    ~conditions:
      [ Equal_value { symbol = Triangle; value = Four }
      ; Equal_value { symbol = Square; value = Four }
      ; Equal_value { symbol = Circle; value = Four }
      ]
;;

let v_33 =
  create
    ~index:33
    ~conditions:
      [ Is_even { symbol = Triangle }
      ; Is_even { symbol = Square }
      ; Is_even { symbol = Circle }
      ]
;;

let v_34 =
  create
    ~index:34
    ~conditions:
      [ Is_smallest_or_equally_smallest { symbol = Triangle }
      ; Is_smallest_or_equally_smallest { symbol = Square }
      ; Is_smallest_or_equally_smallest { symbol = Circle }
      ]
;;

let v_40 =
  create
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
