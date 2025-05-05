let config = Config.load_exn ()
let decoder_01 = Config.decoder_exn config [ 4; 9; 11; 14 ]

let%expect_test "one verifier" =
  let decoder = Config.decoder_exn config [ 4 ] in
  let hypotheses = Decoder.hypotheses decoder ~strict:false in
  print_s [%sexp (hypotheses : Decoder.Hypothesis.t list)];
  [%expect
    {|
    (((number_of_remaining_codes 75)
      (verifiers ((
        (verifier_index 4)
        (criteria (
          (index 0)
          (predicate (
            Compare_symbol_with_value
            (symbol   Square)
            (ordering Less)
            (value    4)))))))))
     ((number_of_remaining_codes 25)
      (verifiers ((
        (verifier_index 4)
        (criteria (
          (index 1)
          (predicate (
            Compare_symbol_with_value
            (symbol   Square)
            (ordering Equal)
            (value    4)))))))))
     ((number_of_remaining_codes 25)
      (verifiers ((
        (verifier_index 4)
        (criteria (
          (index 2)
          (predicate (
            Compare_symbol_with_value
            (symbol   Square)
            (ordering Greater)
            (value    4)))))))))) |}];
  let decoder = Config.decoder_exn config [ 34 ] in
  let hypotheses = Decoder.hypotheses decoder ~strict:false in
  print_s [%sexp (hypotheses : Decoder.Hypothesis.t list)];
  [%expect
    {|
    (((number_of_remaining_codes 55)
      (verifiers ((
        (verifier_index 34)
        (criteria (
          (index 0)
          (predicate (
            Compare_symbol_with_others (symbol Triangle) (orderings (Less Equal))))))))))
     ((number_of_remaining_codes 55)
      (verifiers ((
        (verifier_index 34)
        (criteria (
          (index 1)
          (predicate (
            Compare_symbol_with_others (symbol Square) (orderings (Less Equal))))))))))
     ((number_of_remaining_codes 55)
      (verifiers ((
        (verifier_index 34)
        (criteria (
          (index 2)
          (predicate (
            Compare_symbol_with_others (symbol Circle) (orderings (Less Equal))))))))))) |}];
  ()
;;

let evaluate_test ~decoder ~code ~verifier_index ~result =
  let verifier = Config.find_verifier_exn config ~index:verifier_index in
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
    match Decoder.add_test_result decoder ~code ~verifier_index ~result with
    | Ok decoder -> Decoder.remaining_codes decoder
    | Inconsistency _ -> Codes.empty
  in
  let remaining_number = Codes.length remaining_codes in
  let expected_information_gained = if result then score_if_true else score_if_false in
  let verifier_index = verifier.index in
  print_s
    [%sexp
      { code : Code.t
      ; verifier_index : int
      ; result : bool
      ; remaining_codes : Codes.With_sorted_sexp.t
      ; starting_number : int
      ; remaining_number : int
      ; info : Info.t
      ; expected_information_gained : Interactive_solver.Expected_information_gained.t
      }];
  expected_information_gained
;;

let%expect_test "initial hypotheses" =
  let decoder = decoder_01 in
  print_s [%sexp (Decoder.remaining_codes decoder : Codes.With_sorted_sexp.t)];
  [%expect {| (221 231 241 443 543 545 553) |}];
  ()
;;

let%expect_test "remaining codes" =
  let decoder = Config.decoder_exn config [ 11; 22; 30; 33; 34; 40 ] in
  let code = { Symbol.Tuple.triangle = Digit.Three; square = Three; circle = Four } in
  let t_true = evaluate_test ~decoder ~code ~verifier_index:34 ~result:true in
  [%expect
    {|
    ((code           334)
     (verifier_index 34)
     (result         true)
     (remaining_codes (
       114
       124
       134
       141
       145
       214
       224
       234
       242
       243
       244
       245
       314
       324
       334
       343
       344
       345
       354
       411
       422
       423
       434
       444
       445
       454
       455
       534
       544
       545))
     (starting_number  45)
     (remaining_number 30)
     (info (
       (code           334)
       (verifier_index 34)
       (score_if_true (
         (bits_gained 0.58496250072115608)
         (probability 0.536697247706422)))
       (score_if_false (
         (bits_gained 0.96829114027266172)
         (probability 0.463302752293578)))))
     (expected_information_gained (
       (bits_gained 0.58496250072115608)
       (probability 0.536697247706422)))) |}];
  let t_false = evaluate_test ~decoder ~code ~verifier_index:34 ~result:false in
  [%expect
    {|
    ((code           334)
     (verifier_index 34)
     (result         false)
     (remaining_codes (
       141
       242
       342
       343
       411
       421
       422
       431
       432
       433
       441
       442
       443
       444
       451
       452
       453
       454
       541
       542
       543
       544
       554))
     (starting_number  45)
     (remaining_number 23)
     (info (
       (code           334)
       (verifier_index 34)
       (score_if_true (
         (bits_gained 0.58496250072115608)
         (probability 0.536697247706422)))
       (score_if_false (
         (bits_gained 0.96829114027266172)
         (probability 0.463302752293578)))))
     (expected_information_gained (
       (bits_gained 0.96829114027266172)
       (probability 0.463302752293578)))) |}];
  let evaluation = Interactive_solver.Evaluation.compute [ t_true; t_false ] in
  print_s [%sexp (evaluation : Interactive_solver.Evaluation.t)];
  [%expect {| ((expected_information_gained 0.7625597144583216)) |}];
  require_does_not_raise [%here] (fun () ->
    if Float.( >= ) (Float.abs (t_true.probability +. t_false.probability -. 1.)) 1e-7
    then
      Err.raise
        [ Pp.text "Probability do not sum to 1"
        ; Err.sexp
            [%sexp
              { t_true : Interactive_solver.Expected_information_gained.t
              ; t_false : Interactive_solver.Expected_information_gained.t
              }]
        ]);
  [%expect {| |}];
  ()
;;

let%expect_test "all verifiers" =
  let decoder = decoder_01 in
  let hypotheses = Decoder.hypotheses decoder in
  print_s [%sexp (hypotheses : Decoder.Hypothesis.t list)];
  [%expect
    {|
    (((code 221)
      (verifiers (
        ((verifier_index 4)
         (criteria (
           (index 0)
           (predicate (
             Compare_symbol_with_value
             (symbol   Square)
             (ordering Less)
             (value    4))))))
        ((verifier_index 9)
         (criteria (
           (index 0)
           (predicate (
             Has_digit_count
             (digit 3)
             (count 0))))))
        ((verifier_index 11)
         (criteria (
           (index 1)
           (predicate (
             Compare_symbols
             (a        Triangle)
             (ordering Equal)
             (b        Square))))))
        ((verifier_index 14)
         (criteria (
           (index 2)
           (predicate (
             Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))
     ((code 231)
      (verifiers (
        ((verifier_index 4)
         (criteria (
           (index 0)
           (predicate (
             Compare_symbol_with_value
             (symbol   Square)
             (ordering Less)
             (value    4))))))
        ((verifier_index 9)
         (criteria (
           (index 1)
           (predicate (
             Has_digit_count
             (digit 3)
             (count 1))))))
        ((verifier_index 11)
         (criteria (
           (index 0)
           (predicate (
             Compare_symbols
             (a        Triangle)
             (ordering Less)
             (b        Square))))))
        ((verifier_index 14)
         (criteria (
           (index 2)
           (predicate (
             Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))
     ((code 241)
      (verifiers (
        ((verifier_index 4)
         (criteria (
           (index 1)
           (predicate (
             Compare_symbol_with_value
             (symbol   Square)
             (ordering Equal)
             (value    4))))))
        ((verifier_index 9)
         (criteria (
           (index 0)
           (predicate (
             Has_digit_count
             (digit 3)
             (count 0))))))
        ((verifier_index 11)
         (criteria (
           (index 0)
           (predicate (
             Compare_symbols
             (a        Triangle)
             (ordering Less)
             (b        Square))))))
        ((verifier_index 14)
         (criteria (
           (index 2)
           (predicate (
             Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))
     ((code 545)
      (verifiers (
        ((verifier_index 4)
         (criteria (
           (index 1)
           (predicate (
             Compare_symbol_with_value
             (symbol   Square)
             (ordering Equal)
             (value    4))))))
        ((verifier_index 9)
         (criteria (
           (index 0)
           (predicate (
             Has_digit_count
             (digit 3)
             (count 0))))))
        ((verifier_index 11)
         (criteria (
           (index 2)
           (predicate (
             Compare_symbols
             (a        Triangle)
             (ordering Greater)
             (b        Square))))))
        ((verifier_index 14)
         (criteria (
           (index 1)
           (predicate (
             Compare_symbol_with_others (symbol Square) (orderings (Less))))))))))
     ((code 443)
      (verifiers (
        ((verifier_index 4)
         (criteria (
           (index 1)
           (predicate (
             Compare_symbol_with_value
             (symbol   Square)
             (ordering Equal)
             (value    4))))))
        ((verifier_index 9)
         (criteria (
           (index 1)
           (predicate (
             Has_digit_count
             (digit 3)
             (count 1))))))
        ((verifier_index 11)
         (criteria (
           (index 1)
           (predicate (
             Compare_symbols
             (a        Triangle)
             (ordering Equal)
             (b        Square))))))
        ((verifier_index 14)
         (criteria (
           (index 2)
           (predicate (
             Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))
     ((code 543)
      (verifiers (
        ((verifier_index 4)
         (criteria (
           (index 1)
           (predicate (
             Compare_symbol_with_value
             (symbol   Square)
             (ordering Equal)
             (value    4))))))
        ((verifier_index 9)
         (criteria (
           (index 1)
           (predicate (
             Has_digit_count
             (digit 3)
             (count 1))))))
        ((verifier_index 11)
         (criteria (
           (index 2)
           (predicate (
             Compare_symbols
             (a        Triangle)
             (ordering Greater)
             (b        Square))))))
        ((verifier_index 14)
         (criteria (
           (index 2)
           (predicate (
             Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))
     ((code 553)
      (verifiers (
        ((verifier_index 4)
         (criteria (
           (index 2)
           (predicate (
             Compare_symbol_with_value
             (symbol   Square)
             (ordering Greater)
             (value    4))))))
        ((verifier_index 9)
         (criteria (
           (index 1)
           (predicate (
             Has_digit_count
             (digit 3)
             (count 1))))))
        ((verifier_index 11)
         (criteria (
           (index 1)
           (predicate (
             Compare_symbols
             (a        Triangle)
             (ordering Equal)
             (b        Square))))))
        ((verifier_index 14)
         (criteria (
           (index 2)
           (predicate (
             Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))) |}];
  ()
;;

let%expect_test "example of path" =
  let decoder = decoder_01 in
  let info ~decoder =
    let number_of_remaining_codes = Decoder.number_of_remaining_codes decoder in
    let hypotheses = Decoder.hypotheses decoder in
    [%sexp { number_of_remaining_codes : int; hypotheses : Decoder.Hypothesis.t list }]
  in
  let sexp_init = ref (info ~decoder) in
  let print_progress ~decoder =
    let sexp = info ~decoder in
    Expect_test_patdiff.print_patdiff_s !sexp_init sexp ~context:3;
    sexp_init := sexp
  in
  let code : Code.t = { triangle = One; square = Two; circle = Three } in
  let test_result_exn result =
    match (result : Decoder.Test_result.t) with
    | Ok decoder -> decoder
    | Inconsistency sexp -> raise_s sexp
  in
  let decoder =
    Decoder.add_test_result decoder ~code ~verifier_index:4 ~result:false
    |> test_result_exn
  in
  print_progress ~decoder;
  [%expect
    {|
    -1,65 +1,5
    -|((number_of_remaining_codes 7)
    +|((number_of_remaining_codes 5)
       (hypotheses (
    -|   ((code 221)
    -|    (verifiers (
    -|      ((verifier_index 4)
    -|       (criteria (
    -|         (index 0)
    -|         (predicate (
    -|           Compare_symbol_with_value
    -|           (symbol   Square)
    -|           (ordering Less)
    -|           (value    4))))))
    -|      ((verifier_index 9)
    -|       (criteria (
    -|         (index 0)
    -|         (predicate (
    -|           Has_digit_count
    -|           (digit 3)
    -|           (count 0))))))
    -|      ((verifier_index 11)
    -|       (criteria (
    -|         (index 1)
    -|         (predicate (
    -|           Compare_symbols
    -|           (a        Triangle)
    -|           (ordering Equal)
    -|           (b        Square))))))
    -|      ((verifier_index 14)
    -|       (criteria (
    -|         (index 2)
    -|         (predicate (
    -|           Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))
    -|   ((code 231)
    -|    (verifiers (
    -|      ((verifier_index 4)
    -|       (criteria (
    -|         (index 0)
    -|         (predicate (
    -|           Compare_symbol_with_value
    -|           (symbol   Square)
    -|           (ordering Less)
    -|           (value    4))))))
    -|      ((verifier_index 9)
    -|       (criteria (
    -|         (index 1)
    -|         (predicate (
    -|           Has_digit_count
    -|           (digit 3)
    -|           (count 1))))))
    -|      ((verifier_index 11)
    -|       (criteria (
    -|         (index 0)
    -|         (predicate (
    -|           Compare_symbols
    -|           (a        Triangle)
    -|           (ordering Less)
    -|           (b        Square))))))
    -|      ((verifier_index 14)
    -|       (criteria (
    -|         (index 2)
    -|         (predicate (
    -|           Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))
         ((code 241)
          (verifiers (
            ((verifier_index 4) |}];
  let code : Code.t = { triangle = One; square = Two; circle = Five } in
  let decoder =
    Decoder.add_test_result decoder ~code ~verifier_index:9 ~result:true
    |> test_result_exn
  in
  print_progress ~decoder;
  [%expect
    {|
    -1,4 +1,4
    -|((number_of_remaining_codes 5)
    +|((number_of_remaining_codes 2)
       (hypotheses (
         ((code 241)
          (verifiers (
    -59,94 +59,4
             (criteria (
               (index 1)
               (predicate (
    -|           Compare_symbol_with_others (symbol Square) (orderings (Less))))))))))
    -|   ((code 443)
    -|    (verifiers (
    -|      ((verifier_index 4)
    -|       (criteria (
    -|         (index 1)
    -|         (predicate (
    -|           Compare_symbol_with_value
    -|           (symbol   Square)
    -|           (ordering Equal)
    -|           (value    4))))))
    -|      ((verifier_index 9)
    -|       (criteria (
    -|         (index 1)
    -|         (predicate (
    -|           Has_digit_count
    -|           (digit 3)
    -|           (count 1))))))
    -|      ((verifier_index 11)
    -|       (criteria (
    -|         (index 1)
    -|         (predicate (
    -|           Compare_symbols
    -|           (a        Triangle)
    -|           (ordering Equal)
    -|           (b        Square))))))
    -|      ((verifier_index 14)
    -|       (criteria (
    -|         (index 2)
    -|         (predicate (
    -|           Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))
    -|   ((code 543)
    -|    (verifiers (
    -|      ((verifier_index 4)
    -|       (criteria (
    -|         (index 1)
    -|         (predicate (
    -|           Compare_symbol_with_value
    -|           (symbol   Square)
    -|           (ordering Equal)
    -|           (value    4))))))
    -|      ((verifier_index 9)
    -|       (criteria (
    -|         (index 1)
    -|         (predicate (
    -|           Has_digit_count
    -|           (digit 3)
    -|           (count 1))))))
    -|      ((verifier_index 11)
    -|       (criteria (
    -|         (index 2)
    -|         (predicate (
    -|           Compare_symbols
    -|           (a        Triangle)
    -|           (ordering Greater)
    -|           (b        Square))))))
    -|      ((verifier_index 14)
    -|       (criteria (
    -|         (index 2)
    -|         (predicate (
    -|           Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))
    -|   ((code 553)
    -|    (verifiers (
    -|      ((verifier_index 4)
    -|       (criteria (
    -|         (index 2)
    -|         (predicate (
    -|           Compare_symbol_with_value
    -|           (symbol   Square)
    -|           (ordering Greater)
    -|           (value    4))))))
    -|      ((verifier_index 9)
    -|       (criteria (
    -|         (index 1)
    -|         (predicate (
    -|           Has_digit_count
    -|           (digit 3)
    -|           (count 1))))))
    -|      ((verifier_index 11)
    -|       (criteria (
    -|         (index 1)
    -|         (predicate (
    -|           Compare_symbols
    -|           (a        Triangle)
    -|           (ordering Equal)
    -|           (b        Square))))))
    -|      ((verifier_index 14)
    -|       (criteria (
    -|         (index 2)
    -|         (predicate (
    -|           Compare_symbol_with_others (symbol Circle) (orderings (Less)))))))))))))
    +|           Compare_symbol_with_others (symbol Square) (orderings (Less))))))))))))) |}];
  let code : Code.t = { triangle = One; square = Two; circle = Five } in
  let decoder =
    Decoder.add_test_result decoder ~code ~verifier_index:11 ~result:true
    |> test_result_exn
  in
  print_progress ~decoder;
  [%expect
    {|
    -1,6 +1,6
    -|((number_of_remaining_codes 2)
    +|((number_of_remaining_codes 1)
    -| (hypotheses (
    -|   ((code 241)
    +| (hypotheses ((
    +|   (code 241)
         (verifiers (
           ((verifier_index 4)
            (criteria (
    -29,34 +29,4
            (criteria (
              (index 2)
              (predicate (
    -|           Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))
    -|   ((code 545)
    -|    (verifiers (
    -|      ((verifier_index 4)
    -|       (criteria (
    -|         (index 1)
    -|         (predicate (
    -|           Compare_symbol_with_value
    -|           (symbol   Square)
    -|           (ordering Equal)
    -|           (value    4))))))
    -|      ((verifier_index 9)
    -|       (criteria (
    -|         (index 0)
    -|         (predicate (
    -|           Has_digit_count
    -|           (digit 3)
    -|           (count 0))))))
    -|      ((verifier_index 11)
    -|       (criteria (
    -|         (index 2)
    -|         (predicate (
    -|           Compare_symbols
    -|           (a        Triangle)
    -|           (ordering Greater)
    -|           (b        Square))))))
    -|      ((verifier_index 14)
    -|       (criteria (
    -|         (index 1)
    -|         (predicate (
    -|           Compare_symbol_with_others (symbol Square) (orderings (Less)))))))))))))
    +|          Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))))) |}];
  let code : Code.t = { triangle = One; square = Two; circle = Five } in
  let decoder =
    Decoder.add_test_result decoder ~code ~verifier_index:14 ~result:false
    |> test_result_exn
  in
  print_progress ~decoder;
  [%expect {| |}];
  print_s (info ~decoder);
  [%expect
    {|
    ((number_of_remaining_codes 1)
     (hypotheses ((
       (code 241)
       (verifiers (
         ((verifier_index 4)
          (criteria (
            (index 1)
            (predicate (
              Compare_symbol_with_value
              (symbol   Square)
              (ordering Equal)
              (value    4))))))
         ((verifier_index 9)
          (criteria (
            (index 0)
            (predicate (
              Has_digit_count
              (digit 3)
              (count 0))))))
         ((verifier_index 11)
          (criteria (
            (index 0)
            (predicate (
              Compare_symbols
              (a        Triangle)
              (ordering Less)
              (b        Square))))))
         ((verifier_index 14)
          (criteria (
            (index 2)
            (predicate (
              Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))))) |}];
  ()
;;
