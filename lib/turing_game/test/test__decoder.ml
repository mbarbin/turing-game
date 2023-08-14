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
       (((verifier_name 04)
         (criteria
          ((index 0) (condition (Less_than_value (symbol Square) (value 4)))))))))
     ((number_of_remaining_codes 25)
      (verifiers
       (((verifier_name 04)
         (criteria
          ((index 1) (condition (Equal_value (symbol Square) (value 4)))))))))
     ((number_of_remaining_codes 25)
      (verifiers
       (((verifier_name 04)
         (criteria
          ((index 2) (condition (Greater_than_value (symbol Square) (value 4)))))))))) |}];
  let decoder = Decoder.create ~verifiers:Verifiers.[ v_34 ] in
  let hypotheses = Decoder.hypotheses decoder ~strict:false in
  print_s [%sexp (hypotheses : Decoder.Hypothesis.t list)];
  [%expect
    {|
    (((number_of_remaining_codes 55)
      (verifiers
       (((verifier_name 34)
         (criteria
          ((index 0)
           (condition (Is_smallest_or_equally_smallest (symbol Triangle)))))))))
     ((number_of_remaining_codes 55)
      (verifiers
       (((verifier_name 34)
         (criteria
          ((index 1)
           (condition (Is_smallest_or_equally_smallest (symbol Square)))))))))
     ((number_of_remaining_codes 55)
      (verifiers
       (((verifier_name 34)
         (criteria
          ((index 2)
           (condition (Is_smallest_or_equally_smallest (symbol Circle)))))))))) |}];
  ()
;;

let evaluate_test ~decoder ~code ~verifier ~result =
  let { Interactive_solver.Test_evaluation.evaluation = _
      ; score_if_true
      ; score_if_false
      ; info
      }
    =
    Interactive_solver.evaluate_test ~decoder ~code ~verifier
  in
  let starting_number = Decoder.number_of_remaining_codes decoder in
  let remaining_codes =
    match Decoder.add_test_result decoder ~code ~verifier ~result with
    | Ok decoder -> Decoder.remaining_codes decoder
    | Error _ -> Codes.empty
  in
  let remaining_number = Codes.length remaining_codes in
  let expected_information_gained = if result then score_if_true else score_if_false in
  let verifier_name = verifier.verifier_name in
  print_s
    [%sexp
      { code : Code.t
      ; verifier_name : Verifier_name.t
      ; result : bool
      ; remaining_codes : Codes.t
      ; starting_number : int
      ; remaining_number : int
      ; info : Info.t
      ; expected_information_gained : Interactive_solver.Expected_information_gained.t
      }];
  expected_information_gained
;;

let%expect_test "remaining codes" =
  let decoder = Decoders.v_20 in
  let code = { Symbol.Tuple.triangle = Digit.Three; square = Three; circle = Four } in
  let t_true = evaluate_test ~decoder ~code ~verifier:Verifiers.v_34 ~result:true in
  [%expect
    {|
    ((code 334) (verifier_name 34) (result true)
     (remaining_codes
      (245 345 234 124 454 242 243 244 344 444 224 334 422 423 434 544 214 324))
     (starting_number 29) (remaining_number 18)
     (info
      ((code 334) (verifier_name 34)
       (score_if_true
        ((bits_gained 0.68805599368525971) (probability 0.52671755725190839)))
       (score_if_false
        ((bits_gained 0.85798099512757187) (probability 0.47328244274809161)))))
     (expected_information_gained
      ((bits_gained 0.68805599368525971) (probability 0.52671755725190839)))) |}];
  let t_false = evaluate_test ~decoder ~code ~verifier:Verifiers.v_34 ~result:false in
  [%expect
    {|
    ((code 334) (verifier_name 34) (result false)
     (remaining_codes
      (453 454 452 343 242 342 443 444 442 421 432 543 542 433 422 544))
     (starting_number 29) (remaining_number 16)
     (info
      ((code 334) (verifier_name 34)
       (score_if_true
        ((bits_gained 0.68805599368525971) (probability 0.52671755725190839)))
       (score_if_false
        ((bits_gained 0.85798099512757187) (probability 0.47328244274809161)))))
     (expected_information_gained
      ((bits_gained 0.85798099512757187) (probability 0.47328244274809161)))) |}];
  Expect_test_helpers_base.require_ok
    ~cr:CR_soon
    [%here]
    (if Float.equal (t_true.probability +. t_false.probability) 0.
     then Ok ()
     else
       Or_error.error_s
         [%sexp
           "Probability do not sum to 1"
           , { t_true : Interactive_solver.Expected_information_gained.t
             ; t_false : Interactive_solver.Expected_information_gained.t
             }]);
  [%expect
    {|
    (* CR-soon require-failed: lib/turing_game/test/test__decoder.ml:LINE:COL.
       Do not 'X' this CR; instead make the required property true,
       which will make the CR disappear.  For more information, see
       [Expect_test_helpers_base.require]. *)
    ("unexpected [Error]" (
      "Probability do not sum to 1" (
        (t_true (
          (bits_gained 0.68805599368525971)
          (probability 0.52671755725190839)))
        (t_false (
          (bits_gained 0.85798099512757187)
          (probability 0.47328244274809161)))))) |}];
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
       (((verifier_name 04)
         (criteria
          ((index 0) (condition (Less_than_value (symbol Square) (value 4))))))
        ((verifier_name 09)
         (criteria ((index 0) (condition (Has_digit_count (digit 3) (count 0))))))
        ((verifier_name 11)
         (criteria ((index 1) (condition (Equal (a Triangle) (b Square))))))
        ((verifier_name 14)
         (criteria ((index 2) (condition (Is_smallest (symbol Circle)))))))))
     ((code 231)
      (verifiers
       (((verifier_name 04)
         (criteria
          ((index 0) (condition (Less_than_value (symbol Square) (value 4))))))
        ((verifier_name 09)
         (criteria ((index 1) (condition (Has_digit_count (digit 3) (count 1))))))
        ((verifier_name 11)
         (criteria ((index 0) (condition (Less_than (a Triangle) (b Square))))))
        ((verifier_name 14)
         (criteria ((index 2) (condition (Is_smallest (symbol Circle)))))))))
     ((code 241)
      (verifiers
       (((verifier_name 04)
         (criteria
          ((index 1) (condition (Equal_value (symbol Square) (value 4))))))
        ((verifier_name 09)
         (criteria ((index 0) (condition (Has_digit_count (digit 3) (count 0))))))
        ((verifier_name 11)
         (criteria ((index 0) (condition (Less_than (a Triangle) (b Square))))))
        ((verifier_name 14)
         (criteria ((index 2) (condition (Is_smallest (symbol Circle)))))))))
     ((code 545)
      (verifiers
       (((verifier_name 04)
         (criteria
          ((index 1) (condition (Equal_value (symbol Square) (value 4))))))
        ((verifier_name 09)
         (criteria ((index 0) (condition (Has_digit_count (digit 3) (count 0))))))
        ((verifier_name 11)
         (criteria
          ((index 2) (condition (Greater_than (a Triangle) (b Square))))))
        ((verifier_name 14)
         (criteria ((index 1) (condition (Is_smallest (symbol Square)))))))))
     ((code 443)
      (verifiers
       (((verifier_name 04)
         (criteria
          ((index 1) (condition (Equal_value (symbol Square) (value 4))))))
        ((verifier_name 09)
         (criteria ((index 1) (condition (Has_digit_count (digit 3) (count 1))))))
        ((verifier_name 11)
         (criteria ((index 1) (condition (Equal (a Triangle) (b Square))))))
        ((verifier_name 14)
         (criteria ((index 2) (condition (Is_smallest (symbol Circle)))))))))
     ((code 543)
      (verifiers
       (((verifier_name 04)
         (criteria
          ((index 1) (condition (Equal_value (symbol Square) (value 4))))))
        ((verifier_name 09)
         (criteria ((index 1) (condition (Has_digit_count (digit 3) (count 1))))))
        ((verifier_name 11)
         (criteria
          ((index 2) (condition (Greater_than (a Triangle) (b Square))))))
        ((verifier_name 14)
         (criteria ((index 2) (condition (Is_smallest (symbol Circle)))))))))
     ((code 553)
      (verifiers
       (((verifier_name 04)
         (criteria
          ((index 2) (condition (Greater_than_value (symbol Square) (value 4))))))
        ((verifier_name 09)
         (criteria ((index 1) (condition (Has_digit_count (digit 3) (count 1))))))
        ((verifier_name 11)
         (criteria ((index 1) (condition (Equal (a Triangle) (b Square))))))
        ((verifier_name 14)
         (criteria ((index 2) (condition (Is_smallest (symbol Circle)))))))))) |}];
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
    -     (((verifier_name 04)
    -       (criteria
    -        ((index 0) (condition (Less_than_value (symbol Square) (value 4))))))
    -      ((verifier_name 09)
    -       (criteria ((index 0) (condition (Has_digit_count (digit 3) (count 0))))))
    -      ((verifier_name 11)
    -       (criteria ((index 1) (condition (Equal (a Triangle) (b Square))))))
    -      ((verifier_name 14)
    -       (criteria ((index 2) (condition (Is_smallest (symbol Circle)))))))))
    -   ((code 231)
    -    (verifiers
    -     (((verifier_name 04)
    -       (criteria
    -        ((index 0) (condition (Less_than_value (symbol Square) (value 4))))))
    -      ((verifier_name 09)
    -       (criteria ((index 1) (condition (Has_digit_count (digit 3) (count 1))))))
    -      ((verifier_name 11)
    -       (criteria ((index 0) (condition (Less_than (a Triangle) (b Square))))))
    -      ((verifier_name 14)
    -       (criteria ((index 2) (condition (Is_smallest (symbol Circle)))))))))
        ((code 241)
         (verifiers
                                ...51 unchanged lines...
           ((verifier_name 14)
            (criteria ((index 2) (condition (Is_smallest (symbol Circle)))))))))))) |}];
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
                                ...20 unchanged lines...
           ((verifier_name 14)
            (criteria ((index 1) (condition (Is_smallest (symbol Square)))))))))
    -   ((code 443)
    -    (verifiers
    -     (((verifier_name 04)
    -       (criteria
    -        ((index 1) (condition (Equal_value (symbol Square) (value 4))))))
    -      ((verifier_name 09)
    -       (criteria ((index 1) (condition (Has_digit_count (digit 3) (count 1))))))
    -      ((verifier_name 11)
    -       (criteria ((index 1) (condition (Equal (a Triangle) (b Square))))))
    -      ((verifier_name 14)
    -       (criteria ((index 2) (condition (Is_smallest (symbol Circle)))))))))
    -   ((code 543)
    -    (verifiers
    -     (((verifier_name 04)
    -       (criteria
    -        ((index 1) (condition (Equal_value (symbol Square) (value 4))))))
    -      ((verifier_name 09)
    -       (criteria ((index 1) (condition (Has_digit_count (digit 3) (count 1))))))
    -      ((verifier_name 11)
    -       (criteria ((index 2) (condition (Greater_than (a Triangle) (b Square))))))
    -      ((verifier_name 14)
    -       (criteria ((index 2) (condition (Is_smallest (symbol Circle)))))))))
    -   ((code 553)
    -    (verifiers
    -     (((verifier_name 04)
    -       (criteria
    -        ((index 2) (condition (Greater_than_value (symbol Square) (value 4))))))
    -      ((verifier_name 09)
    -       (criteria ((index 1) (condition (Has_digit_count (digit 3) (count 1))))))
    -      ((verifier_name 11)
    -       (criteria ((index 1) (condition (Equal (a Triangle) (b Square))))))
    -      ((verifier_name 14)
    -       (criteria ((index 2) (condition (Is_smallest (symbol Circle)))))))))
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
                                 ...9 unchanged lines...
           ((verifier_name 14)
            (criteria ((index 2) (condition (Is_smallest (symbol Circle)))))))))
    -   ((code 545)
    -    (verifiers
    -     (((verifier_name 04)
    -       (criteria
    -        ((index 1) (condition (Equal_value (symbol Square) (value 4))))))
    -      ((verifier_name 09)
    -       (criteria ((index 0) (condition (Has_digit_count (digit 3) (count 0))))))
    -      ((verifier_name 11)
    -       (criteria ((index 2) (condition (Greater_than (a Triangle) (b Square))))))
    -      ((verifier_name 14)
    -       (criteria ((index 1) (condition (Is_smallest (symbol Square)))))))))
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
         (((verifier_name 04)
           (criteria
            ((index 1) (condition (Equal_value (symbol Square) (value 4))))))
          ((verifier_name 09)
           (criteria
            ((index 0) (condition (Has_digit_count (digit 3) (count 0))))))
          ((verifier_name 11)
           (criteria ((index 0) (condition (Less_than (a Triangle) (b Square))))))
          ((verifier_name 14)
           (criteria ((index 2) (condition (Is_smallest (symbol Circle)))))))))))) |}];
  ()
;;
