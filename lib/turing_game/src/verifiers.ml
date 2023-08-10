open! Core

type t = Verifier.t

let create = Verifier.create

let v_03 =
  create
    ~name:"03"
    ~conditions:
      [ Less_than_value { symbol = Square; value = Three }
      ; Equal_value { symbol = Square; value = Three }
      ; Greater_than_value { symbol = Square; value = Three }
      ]
;;

let v_04 =
  create
    ~name:"04"
    ~conditions:
      [ Less_than_value { symbol = Square; value = Four }
      ; Equal_value { symbol = Square; value = Four }
      ; Greater_than_value { symbol = Square; value = Four }
      ]
;;

let v_07 =
  create
    ~name:"07"
    ~conditions:[ Is_even { symbol = Circle }; Is_odd { symbol = Circle } ]
;;

let v_09 =
  create
    ~name:"09"
    ~conditions:
      [ Has_digit_count { digit = Three; count = 0 }
      ; Has_digit_count { digit = Three; count = 1 }
      ; Has_digit_count { digit = Three; count = 2 }
      ; Has_digit_count { digit = Three; count = 3 }
      ]
;;

let v_10 =
  create
    ~name:"10"
    ~conditions:
      [ Has_digit_count { digit = Four; count = 0 }
      ; Has_digit_count { digit = Four; count = 1 }
      ; Has_digit_count { digit = Four; count = 2 }
      ; Has_digit_count { digit = Four; count = 3 }
      ]
;;

let v_11 =
  create
    ~name:"11"
    ~conditions:
      [ Less_than { a = Triangle; b = Square }
      ; Equal { a = Triangle; b = Square }
      ; Greater_than { a = Triangle; b = Square }
      ]
;;

let v_14 =
  create
    ~name:"14"
    ~conditions:
      [ Is_smallest { symbol = Triangle }
      ; Is_smallest { symbol = Square }
      ; Is_smallest { symbol = Circle }
      ]
;;

let v_22 =
  create
    ~name:"22"
    ~conditions:[ Are_increasing; Are_decreasing; Are_neither_increasing_nor_decreasing ]
;;

let v_30 =
  create
    ~name:"30"
    ~conditions:
      [ Equal_value { symbol = Triangle; value = Four }
      ; Equal_value { symbol = Square; value = Four }
      ; Equal_value { symbol = Circle; value = Four }
      ]
;;

let v_33 =
  create
    ~name:"33"
    ~conditions:
      [ Is_even { symbol = Triangle }
      ; Is_even { symbol = Square }
      ; Is_even { symbol = Circle }
      ]
;;

let v_34 =
  create
    ~name:"34"
    ~conditions:
      [ Is_smallest_or_equally_smallest { symbol = Triangle }
      ; Is_smallest_or_equally_smallest { symbol = Square }
      ; Is_smallest_or_equally_smallest { symbol = Circle }
      ]
;;

let v_40 =
  create
    ~name:"40"
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
