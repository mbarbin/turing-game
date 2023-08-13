open! Core
open! Turing_game

let%expect_test "one verifier" =
  let decoder = Decoder.create ~verifiers:Verifiers.[ v_04 ] in
  let hypotheses = Decoder.hypotheses decoder ~strict:false in
  print_s [%sexp (hypotheses : Decoder.Hypothesis.t list)];
  [%expect
    {|
    (((number_of_remaining_codes 75)
      (verifiers
       (((name 04) (condition (Less_than_value (symbol Square) (value 4)))))))
     ((number_of_remaining_codes 25)
      (verifiers
       (((name 04) (condition (Equal_value (symbol Square) (value 4)))))))
     ((number_of_remaining_codes 25)
      (verifiers
       (((name 04) (condition (Greater_than_value (symbol Square) (value 4)))))))) |}];
  let decoder = Decoder.create ~verifiers:Verifiers.[ v_34 ] in
  let hypotheses = Decoder.hypotheses decoder ~strict:false in
  print_s [%sexp (hypotheses : Decoder.Hypothesis.t list)];
  [%expect
    {|
    (((number_of_remaining_codes 55)
      (verifiers
       (((name 34)
         (condition (Is_smallest_or_equally_smallest (symbol Triangle)))))))
     ((number_of_remaining_codes 55)
      (verifiers
       (((name 34) (condition (Is_smallest_or_equally_smallest (symbol Square)))))))
     ((number_of_remaining_codes 55)
      (verifiers
       (((name 34) (condition (Is_smallest_or_equally_smallest (symbol Circle)))))))) |}];
  ()
;;

let%expect_test "remaining codes" =
  let decoder = Decoders.v_20 in
  let starting_number = Decoder.number_of_remaining_codes decoder in
  let test ~code ~verifier ~result =
    let remaining_codes =
      match
        Decoder.add_test_result
          decoder
          ~code
          ~verifier:(Decoder.verifier_exn decoder ~name:verifier)
          ~result
      with
      | Ok decoder -> Decoder.remaining_codes decoder
      | Error _ -> Codes.empty
    in
    let remaining_number = Codes.length remaining_codes in
    let expected_information_gained =
      Interactive_solver.Expected_information_gained.compute
        ~starting_number
        ~remaining_number
    in
    print_s
      [%sexp
        { code : Code.t
        ; verifier : Verifier.Name.t
        ; result : bool
        ; remaining_codes : Codes.t
        ; starting_number : int
        ; remaining_number : int
        ; expected_information_gained : Interactive_solver.Expected_information_gained.t
        }]
  in
  let code = { Symbol.Tuple.triangle = Digit.Three; square = Three; circle = Four } in
  test ~code ~verifier:Verifiers.v_34.name ~result:true;
  [%expect
    {|
    ((code 334) (verifier 34) (result true)
     (remaining_codes
      (245 345 234 124 454 242 243 244 344 444 224 334 422 423 434 544 214 324))
     (starting_number 29) (remaining_number 18)
     (expected_information_gained
      ((bits_gained 0.68805599368525971) (probability 0.62068965517241381)))) |}];
  test ~code ~verifier:Verifiers.v_34.name ~result:false;
  [%expect
    {|
    ((code 334) (verifier 34) (result false)
     (remaining_codes
      (453 454 452 343 242 342 443 444 442 421 432 543 542 433 422 544))
     (starting_number 29) (remaining_number 16)
     (expected_information_gained
      ((bits_gained 0.85798099512757187) (probability 0.55172413793103448)))) |}];
  ()
;;

let%expect_test "all verifiers" =
  let decoder = Decoders.v_01 in
  let hypotheses = Decoder.hypotheses decoder in
  print_s [%sexp (hypotheses : Decoder.Hypothesis.t list)];
  [%expect
    {|
    (((code 221)
      (verifiers
       (((name 04) (condition (Less_than_value (symbol Square) (value 4))))
        ((name 09) (condition (Has_digit_count (digit 3) (count 0))))
        ((name 11) (condition (Equal (a Triangle) (b Square))))
        ((name 14) (condition (Is_smallest (symbol Circle)))))))
     ((code 231)
      (verifiers
       (((name 04) (condition (Less_than_value (symbol Square) (value 4))))
        ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
        ((name 11) (condition (Less_than (a Triangle) (b Square))))
        ((name 14) (condition (Is_smallest (symbol Circle)))))))
     ((code 241)
      (verifiers
       (((name 04) (condition (Equal_value (symbol Square) (value 4))))
        ((name 09) (condition (Has_digit_count (digit 3) (count 0))))
        ((name 11) (condition (Less_than (a Triangle) (b Square))))
        ((name 14) (condition (Is_smallest (symbol Circle)))))))
     ((code 545)
      (verifiers
       (((name 04) (condition (Equal_value (symbol Square) (value 4))))
        ((name 09) (condition (Has_digit_count (digit 3) (count 0))))
        ((name 11) (condition (Greater_than (a Triangle) (b Square))))
        ((name 14) (condition (Is_smallest (symbol Square)))))))
     ((code 443)
      (verifiers
       (((name 04) (condition (Equal_value (symbol Square) (value 4))))
        ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
        ((name 11) (condition (Equal (a Triangle) (b Square))))
        ((name 14) (condition (Is_smallest (symbol Circle)))))))
     ((code 543)
      (verifiers
       (((name 04) (condition (Equal_value (symbol Square) (value 4))))
        ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
        ((name 11) (condition (Greater_than (a Triangle) (b Square))))
        ((name 14) (condition (Is_smallest (symbol Circle)))))))
     ((code 553)
      (verifiers
       (((name 04) (condition (Greater_than_value (symbol Square) (value 4))))
        ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
        ((name 11) (condition (Equal (a Triangle) (b Square))))
        ((name 14) (condition (Is_smallest (symbol Circle)))))))) |}];
  ()
;;

let%expect_test "example of path" =
  let decoder = Decoders.v_01 in
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
    Decoder.add_test_result decoder ~code ~verifier:Verifiers.v_04 ~result:false |> ok_exn
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
    -     (((name 04) (condition (Less_than_value (symbol Square) (value 4))))
    -      ((name 09) (condition (Has_digit_count (digit 3) (count 0))))
    -      ((name 11) (condition (Equal (a Triangle) (b Square))))
    -      ((name 14) (condition (Is_smallest (symbol Circle)))))))
    -   ((code 231)
    -    (verifiers
    -     (((name 04) (condition (Less_than_value (symbol Square) (value 4))))
    -      ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
    -      ((name 11) (condition (Less_than (a Triangle) (b Square))))
    -      ((name 14) (condition (Is_smallest (symbol Circle)))))))
        ((code 241)
         (verifiers
                            ...26 unchanged lines...
           ((name 11) (condition (Equal (a Triangle) (b Square))))
           ((name 14) (condition (Is_smallest (symbol Circle)))))))))) |}];
  let code : Code.t = { triangle = One; square = Two; circle = Five } in
  let decoder =
    Decoder.add_test_result decoder ~code ~verifier:Verifiers.v_09 ~result:true |> ok_exn
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
    -     (((name 04) (condition (Equal_value (symbol Square) (value 4))))
    -      ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
    -      ((name 11) (condition (Equal (a Triangle) (b Square))))
    -      ((name 14) (condition (Is_smallest (symbol Circle)))))))
    -   ((code 543)
    -    (verifiers
    -     (((name 04) (condition (Equal_value (symbol Square) (value 4))))
    -      ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
    -      ((name 11) (condition (Greater_than (a Triangle) (b Square))))
    -      ((name 14) (condition (Is_smallest (symbol Circle)))))))
    -   ((code 553)
    -    (verifiers
    -     (((name 04) (condition (Greater_than_value (symbol Square) (value 4))))
    -      ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
    -      ((name 11) (condition (Equal (a Triangle) (b Square))))
    -      ((name 14) (condition (Is_smallest (symbol Circle)))))))
       ))) |}];
  let code : Code.t = { triangle = One; square = Two; circle = Five } in
  let decoder =
    Decoder.add_test_result decoder ~code ~verifier:Verifiers.v_11 ~result:true |> ok_exn
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
          (((name 04) (condition (Equal_value (symbol Square) (value 4))))
           ((name 09) (condition (Has_digit_count (digit 3) (count 0))))
           ((name 11) (condition (Less_than (a Triangle) (b Square))))
           ((name 14) (condition (Is_smallest (symbol Circle)))))))
    -   ((code 545)
    -    (verifiers
    -     (((name 04) (condition (Equal_value (symbol Square) (value 4))))
    -      ((name 09) (condition (Has_digit_count (digit 3) (count 0))))
    -      ((name 11) (condition (Greater_than (a Triangle) (b Square))))
    -      ((name 14) (condition (Is_smallest (symbol Square)))))))
       ))) |}];
  let code : Code.t = { triangle = One; square = Two; circle = Five } in
  let decoder =
    Decoder.add_test_result decoder ~code ~verifier:Verifiers.v_14 ~result:false |> ok_exn
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
         (((name 04) (condition (Equal_value (symbol Square) (value 4))))
          ((name 09) (condition (Has_digit_count (digit 3) (count 0))))
          ((name 11) (condition (Less_than (a Triangle) (b Square))))
          ((name 14) (condition (Is_smallest (symbol Circle)))))))))) |}];
  ()
;;
