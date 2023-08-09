open! Core
open! Turing_game

let verifier_04 =
  Decoder.Verifier.create
    ~name:"04"
    ~conditions:
      [ Less_than_value { symbol = Square; value = Four }
      ; Equal_value { symbol = Square; value = Four }
      ; Greater_than_value { symbol = Square; value = Four }
      ]
;;

let verifier_09 =
  Decoder.Verifier.create
    ~name:"09"
    ~conditions:
      [ Has_digit_count { digit = Three; count = 0 }
      ; Has_digit_count { digit = Three; count = 1 }
      ; Has_digit_count { digit = Three; count = 2 }
      ; Has_digit_count { digit = Three; count = 3 }
      ]
;;

let verifier_11 =
  Decoder.Verifier.create
    ~name:"11"
    ~conditions:
      [ Less_than { a = Triangle; b = Square }
      ; Equal { a = Triangle; b = Square }
      ; Greater_than { a = Triangle; b = Square }
      ]
;;

let verifier_14 =
  Decoder.Verifier.create
    ~name:"14"
    ~conditions:
      [ Is_smallest { symbol = Triangle }
      ; Is_smallest { symbol = Square }
      ; Is_smallest { symbol = Circle }
      ]
;;

let%expect_test "one verifier" =
  let decoder = Decoder.create ~verifiers:[ verifier_04 ] in
  let hypotheses = Decoder.hypotheses decoder in
  print_s [%sexp (hypotheses : Decoder.Hypothesis.Short_sexp.t list)];
  [%expect
    {|
    (((verifiers ((Less_than_value (symbol Square) (value Four))))
      (number_of_remaining_codes 75))
     ((verifiers ((Equal_value (symbol Square) (value Four))))
      (number_of_remaining_codes 25))
     ((verifiers ((Greater_than_value (symbol Square) (value Four))))
      (number_of_remaining_codes 25))) |}];
  ()
;;

let%expect_test "all verifiers" =
  let decoder =
    Decoder.create ~verifiers:[ verifier_04; verifier_09; verifier_11; verifier_14 ]
  in
  let hypotheses = Decoder.hypotheses decoder in
  print_s [%sexp (hypotheses : Decoder.Hypothesis.Short_sexp.t list)];
  [%expect
    {|
    (((verifiers
       ((Less_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 0))
        (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Triangle))))
      (number_of_remaining_codes 3))
     ((verifiers
       ((Less_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 0)) (Equal (a Triangle) (b Square))
        (Is_smallest (symbol Circle))))
      (number_of_remaining_codes 1))
     ((verifiers
       ((Less_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 0))
        (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Square))))
      (number_of_remaining_codes 13))
     ((verifiers
       ((Less_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 0))
        (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
      (number_of_remaining_codes 2))
     ((verifiers
       ((Less_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 1))
        (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Triangle))))
      (number_of_remaining_codes 6))
     ((verifiers
       ((Less_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 1))
        (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
      (number_of_remaining_codes 1))
     ((verifiers
       ((Less_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 1))
        (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Square))))
      (number_of_remaining_codes 14))
     ((verifiers
       ((Less_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 1))
        (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
      (number_of_remaining_codes 5))
     ((verifiers
       ((Less_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 2))
        (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Triangle))))
      (number_of_remaining_codes 2))
     ((verifiers
       ((Less_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 2)) (Equal (a Triangle) (b Square))
        (Is_smallest (symbol Circle))))
      (number_of_remaining_codes 2))
     ((verifiers
       ((Less_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 2))
        (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Square))))
      (number_of_remaining_codes 2))
     ((verifiers
       ((Equal_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 0))
        (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Triangle))))
      (number_of_remaining_codes 5))
     ((verifiers
       ((Equal_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 0))
        (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
      (number_of_remaining_codes 1))
     ((verifiers
       ((Equal_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 0)) (Equal (a Triangle) (b Square))
        (Is_smallest (symbol Circle))))
      (number_of_remaining_codes 2))
     ((verifiers
       ((Equal_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 0))
        (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Square))))
      (number_of_remaining_codes 1))
     ((verifiers
       ((Equal_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 0))
        (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
      (number_of_remaining_codes 2))
     ((verifiers
       ((Equal_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 1))
        (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Triangle))))
      (number_of_remaining_codes 4))
     ((verifiers
       ((Equal_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 1))
        (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
      (number_of_remaining_codes 2))
     ((verifiers
       ((Equal_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 1)) (Equal (a Triangle) (b Square))
        (Is_smallest (symbol Circle))))
      (number_of_remaining_codes 1))
     ((verifiers
       ((Equal_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 1))
        (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
      (number_of_remaining_codes 1))
     ((verifiers
       ((Greater_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 0))
        (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Triangle))))
      (number_of_remaining_codes 6))
     ((verifiers
       ((Greater_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 0))
        (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
      (number_of_remaining_codes 3))
     ((verifiers
       ((Greater_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 0)) (Equal (a Triangle) (b Square))
        (Is_smallest (symbol Circle))))
      (number_of_remaining_codes 3))
     ((verifiers
       ((Greater_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 1))
        (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Triangle))))
      (number_of_remaining_codes 4))
     ((verifiers
       ((Greater_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 1))
        (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
      (number_of_remaining_codes 3))
     ((verifiers
       ((Greater_than_value (symbol Square) (value Four))
        (Has_digit_count (digit Three) (count 1)) (Equal (a Triangle) (b Square))
        (Is_smallest (symbol Circle))))
      (number_of_remaining_codes 1))) |}];
  ()
;;

let%expect_test "example of path" =
  let decoder =
    Decoder.create ~verifiers:[ verifier_04; verifier_09; verifier_11; verifier_14 ]
  in
  let hypotheses = Decoder.hypotheses decoder in
  let sexp_init = ref [%sexp (hypotheses : Decoder.Hypothesis.Short_sexp.t list)] in
  let print_progress ~decoder =
    let hypotheses = Decoder.hypotheses decoder in
    let sexp = [%sexp (hypotheses : Decoder.Hypothesis.Short_sexp.t list)] in
    let diff = Sexp_diff.Algo.diff ~original:!sexp_init ~updated:sexp () in
    print_string
      (Sexp_diff.Display.display_as_plain_string
         (Sexp_diff.Display.Display_options.create ~num_shown:2 Single_column)
         diff);
    sexp_init := sexp
  in
  let code : Code.t = { triangle = One; square = Two; circle = Three } in
  let decoder =
    Decoder.add_test_result_exn decoder ~verifier:verifier_04 ~code ~result:false
  in
  print_progress ~decoder;
  [%expect
    {|
     (
    - ((verifiers
    -   ((Less_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 0))
    -    (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Triangle))))
    -  (number_of_remaining_codes 3))
    - ((verifiers
    -   ((Less_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 0)) (Equal (a Triangle) (b Square))
    -    (Is_smallest (symbol Circle))))
    -  (number_of_remaining_codes 1))
    - ((verifiers
    -   ((Less_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 0))
    -    (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Square))))
    -  (number_of_remaining_codes 13))
    - ((verifiers
    -   ((Less_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 0))
    -    (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
    -  (number_of_remaining_codes 2))
    - ((verifiers
    -   ((Less_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 1))
    -    (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Triangle))))
    -  (number_of_remaining_codes 6))
    - ((verifiers
    -   ((Less_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 1))
    -    (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
    -  (number_of_remaining_codes 1))
    - ((verifiers
    -   ((Less_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 1))
    -    (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Square))))
    -  (number_of_remaining_codes 14))
    - ((verifiers
    -   ((Less_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 1))
    -    (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
    -  (number_of_remaining_codes 5))
    - ((verifiers
    -   ((Less_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 2))
    -    (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Triangle))))
    -  (number_of_remaining_codes 2))
    - ((verifiers
    -   ((Less_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 2)) (Equal (a Triangle) (b Square))
    -    (Is_smallest (symbol Circle))))
    -  (number_of_remaining_codes 2))
    - ((verifiers
    -   ((Less_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 2))
    -    (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Square))))
    -  (number_of_remaining_codes 2))
      ((verifiers
        ((Equal_value (symbol Square) (value Four))
                              ...71 unchanged lines...
         (Is_smallest (symbol Circle))))
       (number_of_remaining_codes 1))) |}];
  let code : Code.t = { triangle = One; square = Two; circle = Five } in
  let decoder =
    Decoder.add_test_result_exn decoder ~verifier:verifier_09 ~code ~result:true
  in
  print_progress ~decoder;
  [%expect
    {|
     (((verifiers
        ((Equal_value (symbol Square) (value Four))
                              ...21 unchanged lines...
         (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
       (number_of_remaining_codes 2))
    - ((verifiers
    -   ((Equal_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 1))
    -    (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Triangle))))
    -  (number_of_remaining_codes 4))
    - ((verifiers
    -   ((Equal_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 1))
    -    (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
    -  (number_of_remaining_codes 2))
    - ((verifiers
    -   ((Equal_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 1)) (Equal (a Triangle) (b Square))
    -    (Is_smallest (symbol Circle))))
    -  (number_of_remaining_codes 1))
    - ((verifiers
    -   ((Equal_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 1))
    -    (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
    -  (number_of_remaining_codes 1))
      ((verifiers
        ((Greater_than_value (symbol Square) (value Four))
                              ...11 unchanged lines...
         (Is_smallest (symbol Circle))))
       (number_of_remaining_codes 3))
    - ((verifiers
    -   ((Greater_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 1))
    -    (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Triangle))))
    -  (number_of_remaining_codes 4))
    - ((verifiers
    -   ((Greater_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 1))
    -    (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
    -  (number_of_remaining_codes 3))
    - ((verifiers
    -   ((Greater_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 1)) (Equal (a Triangle) (b Square))
    -    (Is_smallest (symbol Circle))))
    -  (number_of_remaining_codes 1))
     ) |}];
  let code : Code.t = { triangle = One; square = Two; circle = Five } in
  let decoder =
    Decoder.add_test_result_exn decoder ~verifier:verifier_11 ~code ~result:true
  in
  print_progress ~decoder;
  [%expect
    {|
     (((verifiers
        ((Equal_value (symbol Square) (value Four))
                               ...6 unchanged lines...
         (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
       (number_of_remaining_codes 1))
    - ((verifiers
    -   ((Equal_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 0)) (Equal (a Triangle) (b Square))
    -    (Is_smallest (symbol Circle))))
    -  (number_of_remaining_codes 2))
    - ((verifiers
    -   ((Equal_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 0))
    -    (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Square))))
    -  (number_of_remaining_codes 1))
    - ((verifiers
    -   ((Equal_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 0))
    -    (Greater_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
    -  (number_of_remaining_codes 2))
      ((verifiers
        ((Greater_than_value (symbol Square) (value Four))
                               ...6 unchanged lines...
         (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
       (number_of_remaining_codes 3))
    - ((verifiers
    -   ((Greater_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 0)) (Equal (a Triangle) (b Square))
    -    (Is_smallest (symbol Circle))))
    -  (number_of_remaining_codes 3))
     ) |}];
  let code : Code.t = { triangle = One; square = Two; circle = Five } in
  let decoder =
    Decoder.add_test_result_exn decoder ~verifier:verifier_14 ~code ~result:false
  in
  print_progress ~decoder;
  [%expect
    {|
     (
    - ((verifiers
    -   ((Equal_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 0))
    -    (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Triangle))))
    -  (number_of_remaining_codes 5))
      ((verifiers
        ((Equal_value (symbol Square) (value Four))
         (Has_digit_count (digit Three) (count 0))
         (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
       (number_of_remaining_codes 1))
    - ((verifiers
    -   ((Greater_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 0))
    -    (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Triangle))))
    -  (number_of_remaining_codes 6))
      ((verifiers
        ((Greater_than_value (symbol Square) (value Four))
         (Has_digit_count (digit Three) (count 0))
         (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
       (number_of_remaining_codes 3))) |}];
  let hypotheses = Decoder.hypotheses decoder in
  print_s [%sexp (hypotheses : Decoder.Hypothesis.t list)];
  [%expect
    {|
    (((verifiers
       (((id
          ((name 04)
           (conditions
            ((Less_than_value (symbol Square) (value Four))
             (Equal_value (symbol Square) (value Four))
             (Greater_than_value (symbol Square) (value Four))))))
         (condition (Equal_value (symbol Square) (value Four))))
        ((id
          ((name 09)
           (conditions
            ((Has_digit_count (digit Three) (count 0))
             (Has_digit_count (digit Three) (count 1))
             (Has_digit_count (digit Three) (count 2))
             (Has_digit_count (digit Three) (count 3))))))
         (condition (Has_digit_count (digit Three) (count 0))))
        ((id
          ((name 11)
           (conditions
            ((Less_than (a Triangle) (b Square)) (Equal (a Triangle) (b Square))
             (Greater_than (a Triangle) (b Square))))))
         (condition (Less_than (a Triangle) (b Square))))
        ((id
          ((name 14)
           (conditions
            ((Is_smallest (symbol Triangle)) (Is_smallest (symbol Square))
             (Is_smallest (symbol Circle))))))
         (condition (Is_smallest (symbol Circle))))))
      (number_of_remaining_codes 1)
      (remaining_codes (((triangle Two) (square Four) (circle One)))))
     ((verifiers
       (((id
          ((name 04)
           (conditions
            ((Less_than_value (symbol Square) (value Four))
             (Equal_value (symbol Square) (value Four))
             (Greater_than_value (symbol Square) (value Four))))))
         (condition (Greater_than_value (symbol Square) (value Four))))
        ((id
          ((name 09)
           (conditions
            ((Has_digit_count (digit Three) (count 0))
             (Has_digit_count (digit Three) (count 1))
             (Has_digit_count (digit Three) (count 2))
             (Has_digit_count (digit Three) (count 3))))))
         (condition (Has_digit_count (digit Three) (count 0))))
        ((id
          ((name 11)
           (conditions
            ((Less_than (a Triangle) (b Square)) (Equal (a Triangle) (b Square))
             (Greater_than (a Triangle) (b Square))))))
         (condition (Less_than (a Triangle) (b Square))))
        ((id
          ((name 14)
           (conditions
            ((Is_smallest (symbol Triangle)) (Is_smallest (symbol Square))
             (Is_smallest (symbol Circle))))))
         (condition (Is_smallest (symbol Circle))))))
      (number_of_remaining_codes 3)
      (remaining_codes
       (((triangle Two) (square Five) (circle One))
        ((triangle Four) (square Five) (circle One))
        ((triangle Four) (square Five) (circle Two)))))) |}];
  let code : Code.t = { triangle = Four; square = Five; circle = One } in
  let decoder =
    Decoder.add_test_result_exn decoder ~verifier:verifier_04 ~code ~result:false
  in
  print_progress ~decoder;
  [%expect
    {|
     (((verifiers
        ((Equal_value (symbol Square) (value Four))
         (Has_digit_count (digit Three) (count 0))
         (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
       (number_of_remaining_codes 1))
    - ((verifiers
    -   ((Greater_than_value (symbol Square) (value Four))
    -    (Has_digit_count (digit Three) (count 0))
    -    (Less_than (a Triangle) (b Square)) (Is_smallest (symbol Circle))))
    -  (number_of_remaining_codes 3))
     ) |}];
  let hypotheses = Decoder.hypotheses decoder in
  print_s [%sexp (hypotheses : Decoder.Hypothesis.t list)];
  [%expect
    {|
    (((verifiers
       (((id
          ((name 04)
           (conditions
            ((Less_than_value (symbol Square) (value Four))
             (Equal_value (symbol Square) (value Four))
             (Greater_than_value (symbol Square) (value Four))))))
         (condition (Equal_value (symbol Square) (value Four))))
        ((id
          ((name 09)
           (conditions
            ((Has_digit_count (digit Three) (count 0))
             (Has_digit_count (digit Three) (count 1))
             (Has_digit_count (digit Three) (count 2))
             (Has_digit_count (digit Three) (count 3))))))
         (condition (Has_digit_count (digit Three) (count 0))))
        ((id
          ((name 11)
           (conditions
            ((Less_than (a Triangle) (b Square)) (Equal (a Triangle) (b Square))
             (Greater_than (a Triangle) (b Square))))))
         (condition (Less_than (a Triangle) (b Square))))
        ((id
          ((name 14)
           (conditions
            ((Is_smallest (symbol Triangle)) (Is_smallest (symbol Square))
             (Is_smallest (symbol Circle))))))
         (condition (Is_smallest (symbol Circle))))))
      (number_of_remaining_codes 1)
      (remaining_codes (((triangle Two) (square Four) (circle One)))))) |}];
  ()
;;
