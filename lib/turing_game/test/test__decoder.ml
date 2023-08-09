open! Core
open! Turing_game

let verifier_04 =
  Verifier.create
    ~name:"04"
    ~conditions:
      [ Less_than_value { symbol = Square; value = Four }
      ; Equal_value { symbol = Square; value = Four }
      ; Greater_than_value { symbol = Square; value = Four }
      ]
;;

let verifier_09 =
  Verifier.create
    ~name:"09"
    ~conditions:
      [ Has_digit_count { digit = Three; count = 0 }
      ; Has_digit_count { digit = Three; count = 1 }
      ; Has_digit_count { digit = Three; count = 2 }
      ; Has_digit_count { digit = Three; count = 3 }
      ]
;;

let verifier_11 =
  Verifier.create
    ~name:"11"
    ~conditions:
      [ Less_than { a = Triangle; b = Square }
      ; Equal { a = Triangle; b = Square }
      ; Greater_than { a = Triangle; b = Square }
      ]
;;

let verifier_14 =
  Verifier.create
    ~name:"14"
    ~conditions:
      [ Is_smallest { symbol = Triangle }
      ; Is_smallest { symbol = Square }
      ; Is_smallest { symbol = Circle }
      ]
;;

let%expect_test "one verifier" =
  let decoder = Decoder.create ~verifiers:[ verifier_04 ] in
  let hypotheses = Decoder.hypotheses decoder ~strict:false in
  print_s [%sexp (hypotheses : Decoder.Hypothesis.t list)];
  [%expect
    {|
    (((number_of_remaining_codes 75)
      (verifiers
       (((name 04) (condition (Less_than_value (symbol Square) (value Four)))))))
     ((number_of_remaining_codes 25)
      (verifiers
       (((name 04) (condition (Equal_value (symbol Square) (value Four)))))))
     ((number_of_remaining_codes 25)
      (verifiers
       (((name 04) (condition (Greater_than_value (symbol Square) (value Four)))))))) |}];
  ()
;;

let%expect_test "all verifiers" =
  let decoder =
    Decoder.create ~verifiers:[ verifier_04; verifier_09; verifier_11; verifier_14 ]
  in
  let hypotheses = Decoder.hypotheses decoder in
  print_s [%sexp (hypotheses : Decoder.Hypothesis.t list)];
  [%expect
    {|
    (((code 221)
      (verifiers
       (((name 04) (condition (Less_than_value (symbol Square) (value Four))))
        ((name 09) (condition (Has_digit_count (digit Three) (count 0))))
        ((name 11) (condition (Equal (a Triangle) (b Square))))
        ((name 14) (condition (Is_smallest (symbol Circle)))))))
     ((code 231)
      (verifiers
       (((name 04) (condition (Less_than_value (symbol Square) (value Four))))
        ((name 09) (condition (Has_digit_count (digit Three) (count 1))))
        ((name 11) (condition (Less_than (a Triangle) (b Square))))
        ((name 14) (condition (Is_smallest (symbol Circle)))))))
     ((code 241)
      (verifiers
       (((name 04) (condition (Equal_value (symbol Square) (value Four))))
        ((name 09) (condition (Has_digit_count (digit Three) (count 0))))
        ((name 11) (condition (Less_than (a Triangle) (b Square))))
        ((name 14) (condition (Is_smallest (symbol Circle)))))))
     ((code 545)
      (verifiers
       (((name 04) (condition (Equal_value (symbol Square) (value Four))))
        ((name 09) (condition (Has_digit_count (digit Three) (count 0))))
        ((name 11) (condition (Greater_than (a Triangle) (b Square))))
        ((name 14) (condition (Is_smallest (symbol Square)))))))
     ((code 443)
      (verifiers
       (((name 04) (condition (Equal_value (symbol Square) (value Four))))
        ((name 09) (condition (Has_digit_count (digit Three) (count 1))))
        ((name 11) (condition (Equal (a Triangle) (b Square))))
        ((name 14) (condition (Is_smallest (symbol Circle)))))))
     ((code 543)
      (verifiers
       (((name 04) (condition (Equal_value (symbol Square) (value Four))))
        ((name 09) (condition (Has_digit_count (digit Three) (count 1))))
        ((name 11) (condition (Greater_than (a Triangle) (b Square))))
        ((name 14) (condition (Is_smallest (symbol Circle)))))))
     ((code 553)
      (verifiers
       (((name 04) (condition (Greater_than_value (symbol Square) (value Four))))
        ((name 09) (condition (Has_digit_count (digit Three) (count 1))))
        ((name 11) (condition (Equal (a Triangle) (b Square))))
        ((name 14) (condition (Is_smallest (symbol Circle)))))))) |}];
  ()
;;

let%expect_test "example of path" =
  let decoder =
    Decoder.create ~verifiers:[ verifier_04; verifier_09; verifier_11; verifier_14 ]
  in
  let info ~decoder =
    let number_of_remaining_codes = Decoder.number_of_remaining_codes decoder in
    let hypotheses = Decoder.hypotheses decoder in
    [%sexp { number_of_remaining_codes : int; hypotheses : Decoder.Hypothesis.t list }]
  in
  let sexp_init = ref (info ~decoder) in
  let print_progress ~decoder =
    let sexp = info ~decoder in
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
     ((number_of_remaining_codes
    -  7
    +  5
      )
      (hypotheses
       (
    -   ((code 221)
    -    (verifiers
    -     (((name 04) (condition (Less_than_value (symbol Square) (value Four))))
    -      ((name 09) (condition (Has_digit_count (digit Three) (count 0))))
    -      ((name 11) (condition (Equal (a Triangle) (b Square))))
    -      ((name 14) (condition (Is_smallest (symbol Circle)))))))
    -   ((code 231)
    -    (verifiers
    -     (((name 04) (condition (Less_than_value (symbol Square) (value Four))))
    -      ((name 09) (condition (Has_digit_count (digit Three) (count 1))))
    -      ((name 11) (condition (Less_than (a Triangle) (b Square))))
    -      ((name 14) (condition (Is_smallest (symbol Circle)))))))
        ((code 241)
         (verifiers
                              ...26 unchanged lines...
           ((name 11) (condition (Equal (a Triangle) (b Square))))
           ((name 14) (condition (Is_smallest (symbol Circle)))))))))) |}];
  let code : Code.t = { triangle = One; square = Two; circle = Five } in
  let decoder =
    Decoder.add_test_result_exn decoder ~verifier:verifier_09 ~code ~result:true
  in
  print_progress ~decoder;
  [%expect
    {|
     ((number_of_remaining_codes
    -  5
    +  2
      )
      (hypotheses
                               ...10 unchanged lines...
           ((name 11) (condition (Greater_than (a Triangle) (b Square))))
           ((name 14) (condition (Is_smallest (symbol Square)))))))
    -   ((code 443)
    -    (verifiers
    -     (((name 04) (condition (Equal_value (symbol Square) (value Four))))
    -      ((name 09) (condition (Has_digit_count (digit Three) (count 1))))
    -      ((name 11) (condition (Equal (a Triangle) (b Square))))
    -      ((name 14) (condition (Is_smallest (symbol Circle)))))))
    -   ((code 543)
    -    (verifiers
    -     (((name 04) (condition (Equal_value (symbol Square) (value Four))))
    -      ((name 09) (condition (Has_digit_count (digit Three) (count 1))))
    -      ((name 11) (condition (Greater_than (a Triangle) (b Square))))
    -      ((name 14) (condition (Is_smallest (symbol Circle)))))))
    -   ((code 553)
    -    (verifiers
    -     (((name 04) (condition (Greater_than_value (symbol Square) (value Four))))
    -      ((name 09) (condition (Has_digit_count (digit Three) (count 1))))
    -      ((name 11) (condition (Equal (a Triangle) (b Square))))
    -      ((name 14) (condition (Is_smallest (symbol Circle)))))))
       ))) |}];
  let code : Code.t = { triangle = One; square = Two; circle = Five } in
  let decoder =
    Decoder.add_test_result_exn decoder ~verifier:verifier_11 ~code ~result:true
  in
  print_progress ~decoder;
  [%expect
    {|
     ((number_of_remaining_codes
    -  2
    +  1
      )
      (hypotheses
       (((code 241)
         (verifiers
          (((name 04) (condition (Equal_value (symbol Square) (value Four))))
           ((name 09) (condition (Has_digit_count (digit Three) (count 0))))
           ((name 11) (condition (Less_than (a Triangle) (b Square))))
           ((name 14) (condition (Is_smallest (symbol Circle)))))))
    -   ((code 545)
    -    (verifiers
    -     (((name 04) (condition (Equal_value (symbol Square) (value Four))))
    -      ((name 09) (condition (Has_digit_count (digit Three) (count 0))))
    -      ((name 11) (condition (Greater_than (a Triangle) (b Square))))
    -      ((name 14) (condition (Is_smallest (symbol Square)))))))
       ))) |}];
  let code : Code.t = { triangle = One; square = Two; circle = Five } in
  let decoder =
    Decoder.add_test_result_exn decoder ~verifier:verifier_14 ~code ~result:false
  in
  print_progress ~decoder;
  [%expect {| (no changes) |}];
  print_s (info ~decoder);
  [%expect
    {|
    ((number_of_remaining_codes 1)
     (hypotheses
      (((code 241)
        (verifiers
         (((name 04) (condition (Equal_value (symbol Square) (value Four))))
          ((name 09) (condition (Has_digit_count (digit Three) (count 0))))
          ((name 11) (condition (Less_than (a Triangle) (b Square))))
          ((name 14) (condition (Is_smallest (symbol Circle)))))))))) |}];
  ()
;;
