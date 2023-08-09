open! Core
open! Turing_game

let test conditions =
  match Partition.create conditions with
  | Ok t -> print_s [%sexp (Partition.counts t : int array)]
  | Error e -> print_s [%sexp (e : Error.t)]
;;

let%expect_test "partition" =
  test [ Const true ];
  [%expect {| (125) |}];
  test [ Equal_value { symbol = Triangle; value = One } ];
  [%expect
    {|
    ("Code does not verify exactly 1 condition"
     ((Equal_value (symbol Triangle) (value One)))
     ((code 211) (verifies (false)))) |}];
  test
    [ Equal_value { symbol = Triangle; value = One }
    ; Greater_than_value { symbol = Triangle; value = One }
    ];
  [%expect {| (25 100) |}];
  test
    [ Less_than_value { symbol = Triangle; value = Two }
    ; Equal_value { symbol = Triangle; value = Two }
    ; Greater_than_value { symbol = Triangle; value = Two }
    ];
  [%expect {| (25 25 75) |}];
  test
    [ Less_than_value { symbol = Triangle; value = One }
    ; Equal_value { symbol = Triangle; value = One }
    ; Greater_than_value { symbol = Triangle; value = One }
    ];
  [%expect
    {|
    ("This partition has empty subsets"
     ((Less_than_value (symbol Triangle) (value One))
      (Equal_value (symbol Triangle) (value One))
      (Greater_than_value (symbol Triangle) (value One)))
     ((counts (0 25 100)))) |}];
  test [ Has_twins true; Has_twins false ];
  [%expect {| (60 65) |}];
  test [ Has_triplets true; Has_triplets false ];
  [%expect {| (5 120) |}];
  test [ Has_triplets true; Has_twins true ];
  [%expect
    {|
    ("Code does not verify exactly 1 condition"
     ((Has_triplets true) (Has_twins true))
     ((code 123) (verifies (false false)))) |}];
  test [ Has_triplets true; Has_twins true; Has_no_triplets_no_twins ];
  [%expect {| (5 60 60) |}];
  test
    [ Has_digit_count { digit = One; count = 0 }
    ; Has_digit_count { digit = One; count = 1 }
    ; Has_digit_count { digit = One; count = 2 }
    ; Has_digit_count { digit = One; count = 3 }
    ];
  [%expect {| (64 48 12 1) |}];
  test [ Less_even_than_odd_digits; More_even_than_odd_digits ];
  [%expect {| (81 44) |}];
  test [ Sum_is_even; Sum_is_odd ];
  [%expect {| (62 63) |}];
  ()
;;
