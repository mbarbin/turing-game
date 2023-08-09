open! Core

module Name = struct
  type t = string [@@deriving compare, equal, hash, sexp_of]
end

type t =
  { name : Name.t
  ; conditions : Condition.t Nonempty_list.t
  }
[@@deriving compare, equal, sexp_of]

let create ~name ~conditions = { name; conditions }

module Examples = struct
  let verifier_04 =
    create
      ~name:"04"
      ~conditions:
        [ Less_than_value { symbol = Square; value = Four }
        ; Equal_value { symbol = Square; value = Four }
        ; Greater_than_value { symbol = Square; value = Four }
        ]
  ;;

  let verifier_09 =
    create
      ~name:"09"
      ~conditions:
        [ Has_digit_count { digit = Three; count = 0 }
        ; Has_digit_count { digit = Three; count = 1 }
        ; Has_digit_count { digit = Three; count = 2 }
        ; Has_digit_count { digit = Three; count = 3 }
        ]
  ;;

  let verifier_11 =
    create
      ~name:"11"
      ~conditions:
        [ Less_than { a = Triangle; b = Square }
        ; Equal { a = Triangle; b = Square }
        ; Greater_than { a = Triangle; b = Square }
        ]
  ;;

  let verifier_14 =
    create
      ~name:"14"
      ~conditions:
        [ Is_smallest { symbol = Triangle }
        ; Is_smallest { symbol = Square }
        ; Is_smallest { symbol = Circle }
        ]
  ;;
end
