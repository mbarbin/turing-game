open! Core
open! Turing_game

let simulate_all_hypotheses ~decoder ?only_first_n () =
  let hypotheses =
    let all = Decoder.hypotheses decoder in
    match only_first_n with
    | None -> all
    | Some n -> List.take all n
  in
  List.iter hypotheses ~f:(fun hypothesis ->
    print_endline "============= NEW HYPOTHESIS =============";
    print_s [%sexp (hypothesis : Decoder.Hypothesis.t)];
    let steps =
      Interactive_solver.simulate_resolution_for_hypothesis ~decoder ~hypothesis
    in
    print_s [%sexp (steps : Interactive_solver.Step.t list)])
;;

let%expect_test "interactive solver simulation decoder 1" =
  simulate_all_hypotheses ~decoder:Decoders.v_01 ();
  [%expect
    {|
    ============= NEW HYPOTHESIS =============
    ((code 221)
     (verifiers
      (((name 04) (condition (Less_than_value (symbol Square) (value 4))))
       ((name 09) (condition (Has_digit_count (digit 3) (count 0))))
       ((name 11) (condition (Equal (a Triangle) (b Square))))
       ((name 14) (condition (Is_smallest (symbol Circle)))))))
    ((Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
     (Request_test
      ((new_round true) (code 211) (verifier 09)
       (info
        ((code 211) (verifier 09)
         (score_if_true
          ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
         (score_if_false
          ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
     (Info
      (Test_result
       ((code 211) (verifier 09)
        (condition (Has_digit_count (digit 3) (count 0))) (result true)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 1.2223924213364481) (remaining_bits 1.5849625007211561)
        (number_of_remaining_codes 3))))
     (Request_test
      ((new_round false) (code 211) (verifier 04)
       (info
        ((code 211) (verifier 04)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 211) (verifier 04)
        (condition (Less_than_value (symbol Square) (value 4))) (result true)
        (remaining_bits_before 1.5849625007211561)
        (bits_gained 1.5849625007211561) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 221))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path ((rounds (((code 211) (verifiers (09 04)))))))
       (cost ((number_of_rounds 1) (number_of_verifiers 2))))))
    ============= NEW HYPOTHESIS =============
    ((code 231)
     (verifiers
      (((name 04) (condition (Less_than_value (symbol Square) (value 4))))
       ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
       ((name 11) (condition (Less_than (a Triangle) (b Square))))
       ((name 14) (condition (Is_smallest (symbol Circle)))))))
    ((Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
     (Request_test
      ((new_round true) (code 211) (verifier 09)
       (info
        ((code 211) (verifier 09)
         (score_if_true
          ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
         (score_if_false
          ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
     (Info
      (Test_result
       ((code 211) (verifier 09)
        (condition (Has_digit_count (digit 3) (count 1))) (result false)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 0.80735492205760417) (remaining_bits 2)
        (number_of_remaining_codes 4))))
     (Request_test
      ((new_round false) (code 211) (verifier 04)
       (info
        ((code 211) (verifier 04)
         (score_if_true ((bits_gained 2) (probability 0.25)))
         (score_if_false ((bits_gained 0.41503749927884392) (probability 0.75)))))))
     (Info
      (Test_result
       ((code 211) (verifier 04)
        (condition (Less_than_value (symbol Square) (value 4))) (result true)
        (remaining_bits_before 2) (bits_gained 2) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 231))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path ((rounds (((code 211) (verifiers (09 04)))))))
       (cost ((number_of_rounds 1) (number_of_verifiers 2))))))
    ============= NEW HYPOTHESIS =============
    ((code 241)
     (verifiers
      (((name 04) (condition (Equal_value (symbol Square) (value 4))))
       ((name 09) (condition (Has_digit_count (digit 3) (count 0))))
       ((name 11) (condition (Less_than (a Triangle) (b Square))))
       ((name 14) (condition (Is_smallest (symbol Circle)))))))
    ((Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
     (Request_test
      ((new_round true) (code 211) (verifier 09)
       (info
        ((code 211) (verifier 09)
         (score_if_true
          ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
         (score_if_false
          ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
     (Info
      (Test_result
       ((code 211) (verifier 09)
        (condition (Has_digit_count (digit 3) (count 0))) (result true)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 1.2223924213364481) (remaining_bits 1.5849625007211561)
        (number_of_remaining_codes 3))))
     (Request_test
      ((new_round false) (code 211) (verifier 04)
       (info
        ((code 211) (verifier 04)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 211) (verifier 04)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 1.5849625007211561)
        (bits_gained 0.58496250072115608) (remaining_bits 1)
        (number_of_remaining_codes 2))))
     (Request_test
      ((new_round false) (code 211) (verifier 11)
       (info
        ((code 211) (verifier 11)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 211) (verifier 11) (condition (Less_than (a Triangle) (b Square)))
        (result false) (remaining_bits_before 1) (bits_gained 1)
        (remaining_bits 0) (number_of_remaining_codes 1))))
     (Propose_solution (code 241))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path ((rounds (((code 211) (verifiers (09 04 11)))))))
       (cost ((number_of_rounds 1) (number_of_verifiers 3))))))
    ============= NEW HYPOTHESIS =============
    ((code 545)
     (verifiers
      (((name 04) (condition (Equal_value (symbol Square) (value 4))))
       ((name 09) (condition (Has_digit_count (digit 3) (count 0))))
       ((name 11) (condition (Greater_than (a Triangle) (b Square))))
       ((name 14) (condition (Is_smallest (symbol Square)))))))
    ((Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
     (Request_test
      ((new_round true) (code 211) (verifier 09)
       (info
        ((code 211) (verifier 09)
         (score_if_true
          ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
         (score_if_false
          ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
     (Info
      (Test_result
       ((code 211) (verifier 09)
        (condition (Has_digit_count (digit 3) (count 0))) (result true)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 1.2223924213364481) (remaining_bits 1.5849625007211561)
        (number_of_remaining_codes 3))))
     (Request_test
      ((new_round false) (code 211) (verifier 04)
       (info
        ((code 211) (verifier 04)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 211) (verifier 04)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 1.5849625007211561)
        (bits_gained 0.58496250072115608) (remaining_bits 1)
        (number_of_remaining_codes 2))))
     (Request_test
      ((new_round false) (code 211) (verifier 11)
       (info
        ((code 211) (verifier 11)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 211) (verifier 11)
        (condition (Greater_than (a Triangle) (b Square))) (result true)
        (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 545))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path ((rounds (((code 211) (verifiers (09 04 11)))))))
       (cost ((number_of_rounds 1) (number_of_verifiers 3))))))
    ============= NEW HYPOTHESIS =============
    ((code 443)
     (verifiers
      (((name 04) (condition (Equal_value (symbol Square) (value 4))))
       ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
       ((name 11) (condition (Equal (a Triangle) (b Square))))
       ((name 14) (condition (Is_smallest (symbol Circle)))))))
    ((Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
     (Request_test
      ((new_round true) (code 211) (verifier 09)
       (info
        ((code 211) (verifier 09)
         (score_if_true
          ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
         (score_if_false
          ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
     (Info
      (Test_result
       ((code 211) (verifier 09)
        (condition (Has_digit_count (digit 3) (count 1))) (result false)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 0.80735492205760417) (remaining_bits 2)
        (number_of_remaining_codes 4))))
     (Request_test
      ((new_round false) (code 211) (verifier 04)
       (info
        ((code 211) (verifier 04)
         (score_if_true ((bits_gained 2) (probability 0.25)))
         (score_if_false ((bits_gained 0.41503749927884392) (probability 0.75)))))))
     (Info
      (Test_result
       ((code 211) (verifier 04)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 2) (bits_gained 0.41503749927884392)
        (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3))))
     (Request_test
      ((new_round false) (code 211) (verifier 11)
       (info
        ((code 211) (verifier 11)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 211) (verifier 11) (condition (Equal (a Triangle) (b Square)))
        (result false) (remaining_bits_before 1.5849625007211561)
        (bits_gained 0.58496250072115608) (remaining_bits 1)
        (number_of_remaining_codes 2))))
     (Request_test
      ((new_round true) (code 141) (verifier 04)
       (info
        ((code 141) (verifier 04)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 141) (verifier 04)
        (condition (Equal_value (symbol Square) (value 4))) (result true)
        (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 443))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path
        ((rounds
          (((code 211) (verifiers (09 04 11))) ((code 141) (verifiers (04)))))))
       (cost ((number_of_rounds 2) (number_of_verifiers 4))))))
    ============= NEW HYPOTHESIS =============
    ((code 543)
     (verifiers
      (((name 04) (condition (Equal_value (symbol Square) (value 4))))
       ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
       ((name 11) (condition (Greater_than (a Triangle) (b Square))))
       ((name 14) (condition (Is_smallest (symbol Circle)))))))
    ((Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
     (Request_test
      ((new_round true) (code 211) (verifier 09)
       (info
        ((code 211) (verifier 09)
         (score_if_true
          ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
         (score_if_false
          ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
     (Info
      (Test_result
       ((code 211) (verifier 09)
        (condition (Has_digit_count (digit 3) (count 1))) (result false)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 0.80735492205760417) (remaining_bits 2)
        (number_of_remaining_codes 4))))
     (Request_test
      ((new_round false) (code 211) (verifier 04)
       (info
        ((code 211) (verifier 04)
         (score_if_true ((bits_gained 2) (probability 0.25)))
         (score_if_false ((bits_gained 0.41503749927884392) (probability 0.75)))))))
     (Info
      (Test_result
       ((code 211) (verifier 04)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 2) (bits_gained 0.41503749927884392)
        (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3))))
     (Request_test
      ((new_round false) (code 211) (verifier 11)
       (info
        ((code 211) (verifier 11)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 211) (verifier 11)
        (condition (Greater_than (a Triangle) (b Square))) (result true)
        (remaining_bits_before 1.5849625007211561)
        (bits_gained 1.5849625007211561) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 543))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path ((rounds (((code 211) (verifiers (09 04 11)))))))
       (cost ((number_of_rounds 1) (number_of_verifiers 3))))))
    ============= NEW HYPOTHESIS =============
    ((code 553)
     (verifiers
      (((name 04) (condition (Greater_than_value (symbol Square) (value 4))))
       ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
       ((name 11) (condition (Equal (a Triangle) (b Square))))
       ((name 14) (condition (Is_smallest (symbol Circle)))))))
    ((Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
     (Request_test
      ((new_round true) (code 211) (verifier 09)
       (info
        ((code 211) (verifier 09)
         (score_if_true
          ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
         (score_if_false
          ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
     (Info
      (Test_result
       ((code 211) (verifier 09)
        (condition (Has_digit_count (digit 3) (count 1))) (result false)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 0.80735492205760417) (remaining_bits 2)
        (number_of_remaining_codes 4))))
     (Request_test
      ((new_round false) (code 211) (verifier 04)
       (info
        ((code 211) (verifier 04)
         (score_if_true ((bits_gained 2) (probability 0.25)))
         (score_if_false ((bits_gained 0.41503749927884392) (probability 0.75)))))))
     (Info
      (Test_result
       ((code 211) (verifier 04)
        (condition (Greater_than_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 2) (bits_gained 0.41503749927884392)
        (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3))))
     (Request_test
      ((new_round false) (code 211) (verifier 11)
       (info
        ((code 211) (verifier 11)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 211) (verifier 11) (condition (Equal (a Triangle) (b Square)))
        (result false) (remaining_bits_before 1.5849625007211561)
        (bits_gained 0.58496250072115608) (remaining_bits 1)
        (number_of_remaining_codes 2))))
     (Request_test
      ((new_round true) (code 141) (verifier 04)
       (info
        ((code 141) (verifier 04)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 141) (verifier 04)
        (condition (Greater_than_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 553))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path
        ((rounds
          (((code 211) (verifiers (09 04 11))) ((code 141) (verifiers (04)))))))
       (cost ((number_of_rounds 2) (number_of_verifiers 4)))))) |}];
  ()
;;

let%expect_test "interactive solver simulation decoder 20" =
  simulate_all_hypotheses ~decoder:Decoders.v_20 ~only_first_n:5 ();
  [%expect
    {|
    ============= NEW HYPOTHESIS =============
    ((code 245)
     (verifiers
      (((name 11) (condition (Less_than (a Triangle) (b Square))))
       ((name 22) (condition Are_increasing))
       ((name 30) (condition (Equal_value (symbol Square) (value 4))))
       ((name 33) (condition (Is_even (symbol Triangle))))
       ((name 34)
        (condition (Is_smallest_or_equally_smallest (symbol Triangle))))
       ((name 40) (condition (Less_than_value (symbol Triangle) (value 3)))))))
    ((Info ((remaining_bits 4.8579809951275719) (number_of_remaining_codes 29)))
     (Request_test
      ((new_round true) (code 334) (verifier 34)
       (info
        ((code 334) (verifier 34)
         (score_if_true
          ((bits_gained 0.68805599368525971) (probability 0.62068965517241381)))
         (score_if_false
          ((bits_gained 0.85798099512757187) (probability 0.55172413793103448)))))))
     (Info
      (Test_result
       ((code 334) (verifier 34)
        (condition (Is_smallest_or_equally_smallest (symbol Triangle)))
        (result true) (remaining_bits_before 4.8579809951275719)
        (bits_gained 0.68805599368525971) (remaining_bits 4.1699250014423122)
        (number_of_remaining_codes 18))))
     (Request_test
      ((new_round false) (code 334) (verifier 30)
       (info
        ((code 334) (verifier 30)
         (score_if_true
          ((bits_gained 0.71049338280501484) (probability 0.61111111111111116)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 334) (verifier 30)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 4.1699250014423122)
        (bits_gained 0.58496250072115608) (remaining_bits 3.5849625007211561)
        (number_of_remaining_codes 12))))
     (Request_test
      ((new_round false) (code 334) (verifier 33)
       (info
        ((code 334) (verifier 33)
         (score_if_true
          ((bits_gained 1.2630344058337939) (probability 0.41666666666666669)))
         (score_if_false
          ((bits_gained 0.7776075786635519) (probability 0.58333333333333337)))))))
     (Info
      (Test_result
       ((code 334) (verifier 33) (condition (Is_even (symbol Triangle)))
        (result false) (remaining_bits_before 3.5849625007211561)
        (bits_gained 0.7776075786635519) (remaining_bits 2.8073549220576042)
        (number_of_remaining_codes 7))))
     (Request_test
      ((new_round true) (code 121) (verifier 33)
       (info
        ((code 121) (verifier 33)
         (score_if_true
          ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
         (score_if_false
          ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
     (Info
      (Test_result
       ((code 121) (verifier 33) (condition (Is_even (symbol Triangle)))
        (result false) (remaining_bits_before 2.8073549220576042)
        (bits_gained 0.80735492205760417) (remaining_bits 2)
        (number_of_remaining_codes 4))))
     (Request_test
      ((new_round false) (code 121) (verifier 22)
       (info
        ((code 121) (verifier 22)
         (score_if_true ((bits_gained 0.41503749927884392) (probability 0.75)))
         (score_if_false ((bits_gained 2) (probability 0.25)))))))
     (Info
      (Test_result
       ((code 121) (verifier 22) (condition Are_increasing) (result false)
        (remaining_bits_before 2) (bits_gained 2) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 245))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path
        ((rounds
          (((code 334) (verifiers (34 30 33))) ((code 121) (verifiers (33 22)))))))
       (cost ((number_of_rounds 2) (number_of_verifiers 5))))))
    ============= NEW HYPOTHESIS =============
    ((code 245)
     (verifiers
      (((name 11) (condition (Less_than (a Triangle) (b Square))))
       ((name 22) (condition Are_increasing))
       ((name 30) (condition (Equal_value (symbol Square) (value 4))))
       ((name 33) (condition (Is_even (symbol Triangle))))
       ((name 34)
        (condition (Is_smallest_or_equally_smallest (symbol Triangle))))
       ((name 40) (condition (Greater_than_value (symbol Square) (value 3)))))))
    ((Info ((remaining_bits 4.8579809951275719) (number_of_remaining_codes 29)))
     (Request_test
      ((new_round true) (code 334) (verifier 34)
       (info
        ((code 334) (verifier 34)
         (score_if_true
          ((bits_gained 0.68805599368525971) (probability 0.62068965517241381)))
         (score_if_false
          ((bits_gained 0.85798099512757187) (probability 0.55172413793103448)))))))
     (Info
      (Test_result
       ((code 334) (verifier 34)
        (condition (Is_smallest_or_equally_smallest (symbol Triangle)))
        (result true) (remaining_bits_before 4.8579809951275719)
        (bits_gained 0.68805599368525971) (remaining_bits 4.1699250014423122)
        (number_of_remaining_codes 18))))
     (Request_test
      ((new_round false) (code 334) (verifier 30)
       (info
        ((code 334) (verifier 30)
         (score_if_true
          ((bits_gained 0.71049338280501484) (probability 0.61111111111111116)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 334) (verifier 30)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 4.1699250014423122)
        (bits_gained 0.58496250072115608) (remaining_bits 3.5849625007211561)
        (number_of_remaining_codes 12))))
     (Request_test
      ((new_round false) (code 334) (verifier 33)
       (info
        ((code 334) (verifier 33)
         (score_if_true
          ((bits_gained 1.2630344058337939) (probability 0.41666666666666669)))
         (score_if_false
          ((bits_gained 0.7776075786635519) (probability 0.58333333333333337)))))))
     (Info
      (Test_result
       ((code 334) (verifier 33) (condition (Is_even (symbol Triangle)))
        (result false) (remaining_bits_before 3.5849625007211561)
        (bits_gained 0.7776075786635519) (remaining_bits 2.8073549220576042)
        (number_of_remaining_codes 7))))
     (Request_test
      ((new_round true) (code 121) (verifier 33)
       (info
        ((code 121) (verifier 33)
         (score_if_true
          ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
         (score_if_false
          ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
     (Info
      (Test_result
       ((code 121) (verifier 33) (condition (Is_even (symbol Triangle)))
        (result false) (remaining_bits_before 2.8073549220576042)
        (bits_gained 0.80735492205760417) (remaining_bits 2)
        (number_of_remaining_codes 4))))
     (Request_test
      ((new_round false) (code 121) (verifier 22)
       (info
        ((code 121) (verifier 22)
         (score_if_true ((bits_gained 0.41503749927884392) (probability 0.75)))
         (score_if_false ((bits_gained 2) (probability 0.25)))))))
     (Info
      (Test_result
       ((code 121) (verifier 22) (condition Are_increasing) (result false)
        (remaining_bits_before 2) (bits_gained 2) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 245))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path
        ((rounds
          (((code 334) (verifiers (34 30 33))) ((code 121) (verifiers (33 22)))))))
       (cost ((number_of_rounds 2) (number_of_verifiers 5))))))
    ============= NEW HYPOTHESIS =============
    ((code 245)
     (verifiers
      (((name 11) (condition (Less_than (a Triangle) (b Square))))
       ((name 22) (condition Are_increasing))
       ((name 30) (condition (Equal_value (symbol Square) (value 4))))
       ((name 33) (condition (Is_even (symbol Triangle))))
       ((name 34)
        (condition (Is_smallest_or_equally_smallest (symbol Triangle))))
       ((name 40) (condition (Greater_than_value (symbol Circle) (value 3)))))))
    ((Info ((remaining_bits 4.8579809951275719) (number_of_remaining_codes 29)))
     (Request_test
      ((new_round true) (code 334) (verifier 34)
       (info
        ((code 334) (verifier 34)
         (score_if_true
          ((bits_gained 0.68805599368525971) (probability 0.62068965517241381)))
         (score_if_false
          ((bits_gained 0.85798099512757187) (probability 0.55172413793103448)))))))
     (Info
      (Test_result
       ((code 334) (verifier 34)
        (condition (Is_smallest_or_equally_smallest (symbol Triangle)))
        (result true) (remaining_bits_before 4.8579809951275719)
        (bits_gained 0.68805599368525971) (remaining_bits 4.1699250014423122)
        (number_of_remaining_codes 18))))
     (Request_test
      ((new_round false) (code 334) (verifier 30)
       (info
        ((code 334) (verifier 30)
         (score_if_true
          ((bits_gained 0.71049338280501484) (probability 0.61111111111111116)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 334) (verifier 30)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 4.1699250014423122)
        (bits_gained 0.58496250072115608) (remaining_bits 3.5849625007211561)
        (number_of_remaining_codes 12))))
     (Request_test
      ((new_round false) (code 334) (verifier 33)
       (info
        ((code 334) (verifier 33)
         (score_if_true
          ((bits_gained 1.2630344058337939) (probability 0.41666666666666669)))
         (score_if_false
          ((bits_gained 0.7776075786635519) (probability 0.58333333333333337)))))))
     (Info
      (Test_result
       ((code 334) (verifier 33) (condition (Is_even (symbol Triangle)))
        (result false) (remaining_bits_before 3.5849625007211561)
        (bits_gained 0.7776075786635519) (remaining_bits 2.8073549220576042)
        (number_of_remaining_codes 7))))
     (Request_test
      ((new_round true) (code 121) (verifier 33)
       (info
        ((code 121) (verifier 33)
         (score_if_true
          ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
         (score_if_false
          ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
     (Info
      (Test_result
       ((code 121) (verifier 33) (condition (Is_even (symbol Triangle)))
        (result false) (remaining_bits_before 2.8073549220576042)
        (bits_gained 0.80735492205760417) (remaining_bits 2)
        (number_of_remaining_codes 4))))
     (Request_test
      ((new_round false) (code 121) (verifier 22)
       (info
        ((code 121) (verifier 22)
         (score_if_true ((bits_gained 0.41503749927884392) (probability 0.75)))
         (score_if_false ((bits_gained 2) (probability 0.25)))))))
     (Info
      (Test_result
       ((code 121) (verifier 22) (condition Are_increasing) (result false)
        (remaining_bits_before 2) (bits_gained 2) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 245))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path
        ((rounds
          (((code 334) (verifiers (34 30 33))) ((code 121) (verifiers (33 22)))))))
       (cost ((number_of_rounds 2) (number_of_verifiers 5))))))
    ============= NEW HYPOTHESIS =============
    ((code 345)
     (verifiers
      (((name 11) (condition (Less_than (a Triangle) (b Square))))
       ((name 22) (condition Are_increasing))
       ((name 30) (condition (Equal_value (symbol Square) (value 4))))
       ((name 33) (condition (Is_even (symbol Square))))
       ((name 34)
        (condition (Is_smallest_or_equally_smallest (symbol Triangle))))
       ((name 40) (condition (Equal_value (symbol Triangle) (value 3)))))))
    ((Info ((remaining_bits 4.8579809951275719) (number_of_remaining_codes 29)))
     (Request_test
      ((new_round true) (code 334) (verifier 34)
       (info
        ((code 334) (verifier 34)
         (score_if_true
          ((bits_gained 0.68805599368525971) (probability 0.62068965517241381)))
         (score_if_false
          ((bits_gained 0.85798099512757187) (probability 0.55172413793103448)))))))
     (Info
      (Test_result
       ((code 334) (verifier 34)
        (condition (Is_smallest_or_equally_smallest (symbol Triangle)))
        (result true) (remaining_bits_before 4.8579809951275719)
        (bits_gained 0.68805599368525971) (remaining_bits 4.1699250014423122)
        (number_of_remaining_codes 18))))
     (Request_test
      ((new_round false) (code 334) (verifier 30)
       (info
        ((code 334) (verifier 30)
         (score_if_true
          ((bits_gained 0.71049338280501484) (probability 0.61111111111111116)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 334) (verifier 30)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 4.1699250014423122)
        (bits_gained 0.58496250072115608) (remaining_bits 3.5849625007211561)
        (number_of_remaining_codes 12))))
     (Request_test
      ((new_round false) (code 334) (verifier 33)
       (info
        ((code 334) (verifier 33)
         (score_if_true
          ((bits_gained 1.2630344058337939) (probability 0.41666666666666669)))
         (score_if_false
          ((bits_gained 0.7776075786635519) (probability 0.58333333333333337)))))))
     (Info
      (Test_result
       ((code 334) (verifier 33) (condition (Is_even (symbol Square)))
        (result false) (remaining_bits_before 3.5849625007211561)
        (bits_gained 0.7776075786635519) (remaining_bits 2.8073549220576042)
        (number_of_remaining_codes 7))))
     (Request_test
      ((new_round true) (code 121) (verifier 33)
       (info
        ((code 121) (verifier 33)
         (score_if_true
          ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
         (score_if_false
          ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
     (Info
      (Test_result
       ((code 121) (verifier 33) (condition (Is_even (symbol Square)))
        (result true) (remaining_bits_before 2.8073549220576042)
        (bits_gained 1.2223924213364481) (remaining_bits 1.5849625007211561)
        (number_of_remaining_codes 3))))
     (Request_test
      ((new_round false) (code 121) (verifier 11)
       (info
        ((code 121) (verifier 11)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 121) (verifier 11) (condition (Less_than (a Triangle) (b Square)))
        (result true) (remaining_bits_before 1.5849625007211561)
        (bits_gained 1.5849625007211561) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 345))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path
        ((rounds
          (((code 334) (verifiers (34 30 33))) ((code 121) (verifiers (33 11)))))))
       (cost ((number_of_rounds 2) (number_of_verifiers 5))))))
    ============= NEW HYPOTHESIS =============
    ((code 234)
     (verifiers
      (((name 11) (condition (Less_than (a Triangle) (b Square))))
       ((name 22) (condition Are_increasing))
       ((name 30) (condition (Equal_value (symbol Circle) (value 4))))
       ((name 33) (condition (Is_even (symbol Triangle))))
       ((name 34)
        (condition (Is_smallest_or_equally_smallest (symbol Triangle))))
       ((name 40) (condition (Less_than_value (symbol Triangle) (value 3)))))))
    ((Info ((remaining_bits 4.8579809951275719) (number_of_remaining_codes 29)))
     (Request_test
      ((new_round true) (code 334) (verifier 34)
       (info
        ((code 334) (verifier 34)
         (score_if_true
          ((bits_gained 0.68805599368525971) (probability 0.62068965517241381)))
         (score_if_false
          ((bits_gained 0.85798099512757187) (probability 0.55172413793103448)))))))
     (Info
      (Test_result
       ((code 334) (verifier 34)
        (condition (Is_smallest_or_equally_smallest (symbol Triangle)))
        (result true) (remaining_bits_before 4.8579809951275719)
        (bits_gained 0.68805599368525971) (remaining_bits 4.1699250014423122)
        (number_of_remaining_codes 18))))
     (Request_test
      ((new_round false) (code 334) (verifier 30)
       (info
        ((code 334) (verifier 30)
         (score_if_true
          ((bits_gained 0.71049338280501484) (probability 0.61111111111111116)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 334) (verifier 30)
        (condition (Equal_value (symbol Circle) (value 4))) (result true)
        (remaining_bits_before 4.1699250014423122)
        (bits_gained 0.71049338280501484) (remaining_bits 3.4594316186372973)
        (number_of_remaining_codes 11))))
     (Request_test
      ((new_round false) (code 334) (verifier 40)
       (info
        ((code 334) (verifier 40)
         (score_if_true
          ((bits_gained 0.87446911791614124) (probability 0.54545454545454541)))
         (score_if_false
          ((bits_gained 0.65207669657969314) (probability 0.63636363636363635)))))))
     (Info
      (Test_result
       ((code 334) (verifier 40)
        (condition (Less_than_value (symbol Triangle) (value 3))) (result false)
        (remaining_bits_before 3.4594316186372973)
        (bits_gained 0.65207669657969314) (remaining_bits 2.8073549220576042)
        (number_of_remaining_codes 7))))
     (Request_test
      ((new_round true) (code 211) (verifier 40)
       (info
        ((code 211) (verifier 40)
         (score_if_true
          ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))
         (score_if_false
          ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))))))
     (Info
      (Test_result
       ((code 211) (verifier 40)
        (condition (Less_than_value (symbol Triangle) (value 3))) (result true)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 0.80735492205760417) (remaining_bits 2)
        (number_of_remaining_codes 4))))
     (Request_test
      ((new_round false) (code 211) (verifier 22)
       (info
        ((code 211) (verifier 22)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 211) (verifier 22) (condition Are_increasing) (result false)
        (remaining_bits_before 2) (bits_gained 1) (remaining_bits 1)
        (number_of_remaining_codes 2))))
     (Request_test
      ((new_round false) (code 211) (verifier 33)
       (info
        ((code 211) (verifier 33)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 211) (verifier 33) (condition (Is_even (symbol Triangle)))
        (result true) (remaining_bits_before 1) (bits_gained 1)
        (remaining_bits 0) (number_of_remaining_codes 1))))
     (Propose_solution (code 234))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path
        ((rounds
          (((code 334) (verifiers (34 30 40)))
           ((code 211) (verifiers (40 22 33)))))))
       (cost ((number_of_rounds 2) (number_of_verifiers 6)))))) |}];
  ()
;;
