open! Core
open! Turing_game

let%expect_test "interactive solver simulation decoder 1" =
  Interactive_solver.simulate_hypotheses ~decoder:Decoders.v_01 ~which_hypotheses:All;
  [%expect
    {|
    ============= NEW HYPOTHESIS =============
    ((code 221)
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
    (Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 211) (verifier_name 09)
      (info
       ((code 211) (verifier_name 09)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 211) (verifier_name 09)
      (condition ((index 0) (condition (Has_digit_count (digit 3) (count 0)))))
      (result true) (remaining_bits_before 2.8073549220576042)
      (bits_gained 1.2223924213364481) (remaining_bits 1.5849625007211561)
      (number_of_remaining_codes 3)))
    (Request_test
     ((new_round false) (code 211) (verifier_name 04)
      (info
       ((code 211) (verifier_name 04)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 211) (verifier_name 04)
      (condition
       ((index 0) (condition (Less_than_value (symbol Square) (value 4)))))
      (result true) (remaining_bits_before 1.5849625007211561)
      (bits_gained 1.5849625007211561) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path ((rounds (((code 211) (verifiers (09 04)))))))
      (cost ((number_of_rounds 1) (number_of_verifiers 2)))))
    (Propose_solution (code 221))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
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
    (Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 211) (verifier_name 09)
      (info
       ((code 211) (verifier_name 09)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 211) (verifier_name 09)
      (condition ((index 1) (condition (Has_digit_count (digit 3) (count 1)))))
      (result false) (remaining_bits_before 2.8073549220576042)
      (bits_gained 0.80735492205760417) (remaining_bits 2)
      (number_of_remaining_codes 4)))
    (Request_test
     ((new_round false) (code 211) (verifier_name 04)
      (info
       ((code 211) (verifier_name 04)
        (score_if_true ((bits_gained 2) (probability 0.25)))
        (score_if_false ((bits_gained 0.41503749927884392) (probability 0.75)))))))
    (Test_result
     ((code 211) (verifier_name 04)
      (condition
       ((index 0) (condition (Less_than_value (symbol Square) (value 4)))))
      (result true) (remaining_bits_before 2) (bits_gained 2) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path ((rounds (((code 211) (verifiers (09 04)))))))
      (cost ((number_of_rounds 1) (number_of_verifiers 2)))))
    (Propose_solution (code 231))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
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
    (Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 211) (verifier_name 09)
      (info
       ((code 211) (verifier_name 09)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 211) (verifier_name 09)
      (condition ((index 0) (condition (Has_digit_count (digit 3) (count 0)))))
      (result true) (remaining_bits_before 2.8073549220576042)
      (bits_gained 1.2223924213364481) (remaining_bits 1.5849625007211561)
      (number_of_remaining_codes 3)))
    (Request_test
     ((new_round false) (code 211) (verifier_name 04)
      (info
       ((code 211) (verifier_name 04)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 211) (verifier_name 04)
      (condition ((index 1) (condition (Equal_value (symbol Square) (value 4)))))
      (result false) (remaining_bits_before 1.5849625007211561)
      (bits_gained 0.58496250072115608) (remaining_bits 1)
      (number_of_remaining_codes 2)))
    (Request_test
     ((new_round false) (code 211) (verifier_name 11)
      (info
       ((code 211) (verifier_name 11)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 211) (verifier_name 11)
      (condition ((index 0) (condition (Less_than (a Triangle) (b Square)))))
      (result false) (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path ((rounds (((code 211) (verifiers (09 04 11)))))))
      (cost ((number_of_rounds 1) (number_of_verifiers 3)))))
    (Propose_solution (code 241))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
    ((code 545)
     (verifiers
      (((verifier_name 04)
        (criteria
         ((index 1) (condition (Equal_value (symbol Square) (value 4))))))
       ((verifier_name 09)
        (criteria ((index 0) (condition (Has_digit_count (digit 3) (count 0))))))
       ((verifier_name 11)
        (criteria ((index 2) (condition (Greater_than (a Triangle) (b Square))))))
       ((verifier_name 14)
        (criteria ((index 1) (condition (Is_smallest (symbol Square)))))))))
    (Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 211) (verifier_name 09)
      (info
       ((code 211) (verifier_name 09)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 211) (verifier_name 09)
      (condition ((index 0) (condition (Has_digit_count (digit 3) (count 0)))))
      (result true) (remaining_bits_before 2.8073549220576042)
      (bits_gained 1.2223924213364481) (remaining_bits 1.5849625007211561)
      (number_of_remaining_codes 3)))
    (Request_test
     ((new_round false) (code 211) (verifier_name 04)
      (info
       ((code 211) (verifier_name 04)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 211) (verifier_name 04)
      (condition ((index 1) (condition (Equal_value (symbol Square) (value 4)))))
      (result false) (remaining_bits_before 1.5849625007211561)
      (bits_gained 0.58496250072115608) (remaining_bits 1)
      (number_of_remaining_codes 2)))
    (Request_test
     ((new_round false) (code 211) (verifier_name 11)
      (info
       ((code 211) (verifier_name 11)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 211) (verifier_name 11)
      (condition ((index 2) (condition (Greater_than (a Triangle) (b Square)))))
      (result true) (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path ((rounds (((code 211) (verifiers (09 04 11)))))))
      (cost ((number_of_rounds 1) (number_of_verifiers 3)))))
    (Propose_solution (code 545))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
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
    (Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 211) (verifier_name 09)
      (info
       ((code 211) (verifier_name 09)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 211) (verifier_name 09)
      (condition ((index 1) (condition (Has_digit_count (digit 3) (count 1)))))
      (result false) (remaining_bits_before 2.8073549220576042)
      (bits_gained 0.80735492205760417) (remaining_bits 2)
      (number_of_remaining_codes 4)))
    (Request_test
     ((new_round false) (code 211) (verifier_name 04)
      (info
       ((code 211) (verifier_name 04)
        (score_if_true ((bits_gained 2) (probability 0.25)))
        (score_if_false ((bits_gained 0.41503749927884392) (probability 0.75)))))))
    (Test_result
     ((code 211) (verifier_name 04)
      (condition ((index 1) (condition (Equal_value (symbol Square) (value 4)))))
      (result false) (remaining_bits_before 2) (bits_gained 0.41503749927884392)
      (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3)))
    (Request_test
     ((new_round false) (code 211) (verifier_name 11)
      (info
       ((code 211) (verifier_name 11)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 211) (verifier_name 11)
      (condition ((index 1) (condition (Equal (a Triangle) (b Square)))))
      (result false) (remaining_bits_before 1.5849625007211561)
      (bits_gained 0.58496250072115608) (remaining_bits 1)
      (number_of_remaining_codes 2)))
    (Request_test
     ((new_round true) (code 141) (verifier_name 04)
      (info
       ((code 141) (verifier_name 04)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 141) (verifier_name 04)
      (condition ((index 1) (condition (Equal_value (symbol Square) (value 4)))))
      (result true) (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path
       ((rounds
         (((code 211) (verifiers (09 04 11))) ((code 141) (verifiers (04)))))))
      (cost ((number_of_rounds 2) (number_of_verifiers 4)))))
    (Propose_solution (code 443))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
    ((code 543)
     (verifiers
      (((verifier_name 04)
        (criteria
         ((index 1) (condition (Equal_value (symbol Square) (value 4))))))
       ((verifier_name 09)
        (criteria ((index 1) (condition (Has_digit_count (digit 3) (count 1))))))
       ((verifier_name 11)
        (criteria ((index 2) (condition (Greater_than (a Triangle) (b Square))))))
       ((verifier_name 14)
        (criteria ((index 2) (condition (Is_smallest (symbol Circle)))))))))
    (Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 211) (verifier_name 09)
      (info
       ((code 211) (verifier_name 09)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 211) (verifier_name 09)
      (condition ((index 1) (condition (Has_digit_count (digit 3) (count 1)))))
      (result false) (remaining_bits_before 2.8073549220576042)
      (bits_gained 0.80735492205760417) (remaining_bits 2)
      (number_of_remaining_codes 4)))
    (Request_test
     ((new_round false) (code 211) (verifier_name 04)
      (info
       ((code 211) (verifier_name 04)
        (score_if_true ((bits_gained 2) (probability 0.25)))
        (score_if_false ((bits_gained 0.41503749927884392) (probability 0.75)))))))
    (Test_result
     ((code 211) (verifier_name 04)
      (condition ((index 1) (condition (Equal_value (symbol Square) (value 4)))))
      (result false) (remaining_bits_before 2) (bits_gained 0.41503749927884392)
      (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3)))
    (Request_test
     ((new_round false) (code 211) (verifier_name 11)
      (info
       ((code 211) (verifier_name 11)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 211) (verifier_name 11)
      (condition ((index 2) (condition (Greater_than (a Triangle) (b Square)))))
      (result true) (remaining_bits_before 1.5849625007211561)
      (bits_gained 1.5849625007211561) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path ((rounds (((code 211) (verifiers (09 04 11)))))))
      (cost ((number_of_rounds 1) (number_of_verifiers 3)))))
    (Propose_solution (code 543))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
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
        (criteria ((index 2) (condition (Is_smallest (symbol Circle)))))))))
    (Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 211) (verifier_name 09)
      (info
       ((code 211) (verifier_name 09)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 211) (verifier_name 09)
      (condition ((index 1) (condition (Has_digit_count (digit 3) (count 1)))))
      (result false) (remaining_bits_before 2.8073549220576042)
      (bits_gained 0.80735492205760417) (remaining_bits 2)
      (number_of_remaining_codes 4)))
    (Request_test
     ((new_round false) (code 211) (verifier_name 04)
      (info
       ((code 211) (verifier_name 04)
        (score_if_true ((bits_gained 2) (probability 0.25)))
        (score_if_false ((bits_gained 0.41503749927884392) (probability 0.75)))))))
    (Test_result
     ((code 211) (verifier_name 04)
      (condition
       ((index 2) (condition (Greater_than_value (symbol Square) (value 4)))))
      (result false) (remaining_bits_before 2) (bits_gained 0.41503749927884392)
      (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3)))
    (Request_test
     ((new_round false) (code 211) (verifier_name 11)
      (info
       ((code 211) (verifier_name 11)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 211) (verifier_name 11)
      (condition ((index 1) (condition (Equal (a Triangle) (b Square)))))
      (result false) (remaining_bits_before 1.5849625007211561)
      (bits_gained 0.58496250072115608) (remaining_bits 1)
      (number_of_remaining_codes 2)))
    (Request_test
     ((new_round true) (code 141) (verifier_name 04)
      (info
       ((code 141) (verifier_name 04)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 141) (verifier_name 04)
      (condition
       ((index 2) (condition (Greater_than_value (symbol Square) (value 4)))))
      (result false) (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path
       ((rounds
         (((code 211) (verifiers (09 04 11))) ((code 141) (verifiers (04)))))))
      (cost ((number_of_rounds 2) (number_of_verifiers 4)))))
    (Propose_solution (code 553))
    (Ok "Code match hypothesis expected code") |}];
  ()
;;

let%expect_test "interactive solver simulation decoder 20" =
  Interactive_solver.simulate_hypotheses
    ~decoder:Decoders.v_20
    ~which_hypotheses:(Only_the_first_n { n = 5 });
  [%expect
    {|
    ============= NEW HYPOTHESIS =============
    ((code 245)
     (verifiers
      (((verifier_name 11)
        (criteria ((index 0) (condition (Less_than (a Triangle) (b Square))))))
       ((verifier_name 22) (criteria ((index 0) (condition Are_increasing))))
       ((verifier_name 30)
        (criteria
         ((index 1) (condition (Equal_value (symbol Square) (value 4))))))
       ((verifier_name 33)
        (criteria ((index 0) (condition (Is_even (symbol Triangle))))))
       ((verifier_name 34)
        (criteria
         ((index 0)
          (condition (Is_smallest_or_equally_smallest (symbol Triangle))))))
       ((verifier_name 40)
        (criteria
         ((index 0) (condition (Less_than_value (symbol Triangle) (value 3)))))))))
    (Info ((remaining_bits 4.8579809951275719) (number_of_remaining_codes 29)))
    (Request_test
     ((new_round true) (code 334) (verifier_name 34)
      (info
       ((code 334) (verifier_name 34)
        (score_if_true
         ((bits_gained 0.68805599368525971) (probability 0.62068965517241381)))
        (score_if_false
         ((bits_gained 0.85798099512757187) (probability 0.55172413793103448)))))))
    (Test_result
     ((code 334) (verifier_name 34)
      (condition
       ((index 0)
        (condition (Is_smallest_or_equally_smallest (symbol Triangle)))))
      (result true) (remaining_bits_before 4.8579809951275719)
      (bits_gained 0.68805599368525971) (remaining_bits 4.1699250014423122)
      (number_of_remaining_codes 18)))
    (Request_test
     ((new_round false) (code 334) (verifier_name 30)
      (info
       ((code 334) (verifier_name 30)
        (score_if_true
         ((bits_gained 0.71049338280501484) (probability 0.61111111111111116)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 334) (verifier_name 30)
      (condition ((index 1) (condition (Equal_value (symbol Square) (value 4)))))
      (result false) (remaining_bits_before 4.1699250014423122)
      (bits_gained 0.58496250072115608) (remaining_bits 3.5849625007211561)
      (number_of_remaining_codes 12)))
    (Request_test
     ((new_round false) (code 334) (verifier_name 33)
      (info
       ((code 334) (verifier_name 33)
        (score_if_true
         ((bits_gained 1.2630344058337939) (probability 0.41666666666666669)))
        (score_if_false
         ((bits_gained 0.7776075786635519) (probability 0.58333333333333337)))))))
    (Test_result
     ((code 334) (verifier_name 33)
      (condition ((index 0) (condition (Is_even (symbol Triangle)))))
      (result false) (remaining_bits_before 3.5849625007211561)
      (bits_gained 0.7776075786635519) (remaining_bits 2.8073549220576042)
      (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 121) (verifier_name 33)
      (info
       ((code 121) (verifier_name 33)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 121) (verifier_name 33)
      (condition ((index 0) (condition (Is_even (symbol Triangle)))))
      (result false) (remaining_bits_before 2.8073549220576042)
      (bits_gained 0.80735492205760417) (remaining_bits 2)
      (number_of_remaining_codes 4)))
    (Request_test
     ((new_round false) (code 121) (verifier_name 22)
      (info
       ((code 121) (verifier_name 22)
        (score_if_true ((bits_gained 0.41503749927884392) (probability 0.75)))
        (score_if_false ((bits_gained 2) (probability 0.25)))))))
    (Test_result
     ((code 121) (verifier_name 22)
      (condition ((index 0) (condition Are_increasing))) (result false)
      (remaining_bits_before 2) (bits_gained 2) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path
       ((rounds
         (((code 334) (verifiers (34 30 33))) ((code 121) (verifiers (33 22)))))))
      (cost ((number_of_rounds 2) (number_of_verifiers 5)))))
    (Propose_solution (code 245))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
    ((code 245)
     (verifiers
      (((verifier_name 11)
        (criteria ((index 0) (condition (Less_than (a Triangle) (b Square))))))
       ((verifier_name 22) (criteria ((index 0) (condition Are_increasing))))
       ((verifier_name 30)
        (criteria
         ((index 1) (condition (Equal_value (symbol Square) (value 4))))))
       ((verifier_name 33)
        (criteria ((index 0) (condition (Is_even (symbol Triangle))))))
       ((verifier_name 34)
        (criteria
         ((index 0)
          (condition (Is_smallest_or_equally_smallest (symbol Triangle))))))
       ((verifier_name 40)
        (criteria
         ((index 5) (condition (Greater_than_value (symbol Square) (value 3)))))))))
    (Info ((remaining_bits 4.8579809951275719) (number_of_remaining_codes 29)))
    (Request_test
     ((new_round true) (code 334) (verifier_name 34)
      (info
       ((code 334) (verifier_name 34)
        (score_if_true
         ((bits_gained 0.68805599368525971) (probability 0.62068965517241381)))
        (score_if_false
         ((bits_gained 0.85798099512757187) (probability 0.55172413793103448)))))))
    (Test_result
     ((code 334) (verifier_name 34)
      (condition
       ((index 0)
        (condition (Is_smallest_or_equally_smallest (symbol Triangle)))))
      (result true) (remaining_bits_before 4.8579809951275719)
      (bits_gained 0.68805599368525971) (remaining_bits 4.1699250014423122)
      (number_of_remaining_codes 18)))
    (Request_test
     ((new_round false) (code 334) (verifier_name 30)
      (info
       ((code 334) (verifier_name 30)
        (score_if_true
         ((bits_gained 0.71049338280501484) (probability 0.61111111111111116)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 334) (verifier_name 30)
      (condition ((index 1) (condition (Equal_value (symbol Square) (value 4)))))
      (result false) (remaining_bits_before 4.1699250014423122)
      (bits_gained 0.58496250072115608) (remaining_bits 3.5849625007211561)
      (number_of_remaining_codes 12)))
    (Request_test
     ((new_round false) (code 334) (verifier_name 33)
      (info
       ((code 334) (verifier_name 33)
        (score_if_true
         ((bits_gained 1.2630344058337939) (probability 0.41666666666666669)))
        (score_if_false
         ((bits_gained 0.7776075786635519) (probability 0.58333333333333337)))))))
    (Test_result
     ((code 334) (verifier_name 33)
      (condition ((index 0) (condition (Is_even (symbol Triangle)))))
      (result false) (remaining_bits_before 3.5849625007211561)
      (bits_gained 0.7776075786635519) (remaining_bits 2.8073549220576042)
      (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 121) (verifier_name 33)
      (info
       ((code 121) (verifier_name 33)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 121) (verifier_name 33)
      (condition ((index 0) (condition (Is_even (symbol Triangle)))))
      (result false) (remaining_bits_before 2.8073549220576042)
      (bits_gained 0.80735492205760417) (remaining_bits 2)
      (number_of_remaining_codes 4)))
    (Request_test
     ((new_round false) (code 121) (verifier_name 22)
      (info
       ((code 121) (verifier_name 22)
        (score_if_true ((bits_gained 0.41503749927884392) (probability 0.75)))
        (score_if_false ((bits_gained 2) (probability 0.25)))))))
    (Test_result
     ((code 121) (verifier_name 22)
      (condition ((index 0) (condition Are_increasing))) (result false)
      (remaining_bits_before 2) (bits_gained 2) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path
       ((rounds
         (((code 334) (verifiers (34 30 33))) ((code 121) (verifiers (33 22)))))))
      (cost ((number_of_rounds 2) (number_of_verifiers 5)))))
    (Propose_solution (code 245))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
    ((code 245)
     (verifiers
      (((verifier_name 11)
        (criteria ((index 0) (condition (Less_than (a Triangle) (b Square))))))
       ((verifier_name 22) (criteria ((index 0) (condition Are_increasing))))
       ((verifier_name 30)
        (criteria
         ((index 1) (condition (Equal_value (symbol Square) (value 4))))))
       ((verifier_name 33)
        (criteria ((index 0) (condition (Is_even (symbol Triangle))))))
       ((verifier_name 34)
        (criteria
         ((index 0)
          (condition (Is_smallest_or_equally_smallest (symbol Triangle))))))
       ((verifier_name 40)
        (criteria
         ((index 8) (condition (Greater_than_value (symbol Circle) (value 3)))))))))
    (Info ((remaining_bits 4.8579809951275719) (number_of_remaining_codes 29)))
    (Request_test
     ((new_round true) (code 334) (verifier_name 34)
      (info
       ((code 334) (verifier_name 34)
        (score_if_true
         ((bits_gained 0.68805599368525971) (probability 0.62068965517241381)))
        (score_if_false
         ((bits_gained 0.85798099512757187) (probability 0.55172413793103448)))))))
    (Test_result
     ((code 334) (verifier_name 34)
      (condition
       ((index 0)
        (condition (Is_smallest_or_equally_smallest (symbol Triangle)))))
      (result true) (remaining_bits_before 4.8579809951275719)
      (bits_gained 0.68805599368525971) (remaining_bits 4.1699250014423122)
      (number_of_remaining_codes 18)))
    (Request_test
     ((new_round false) (code 334) (verifier_name 30)
      (info
       ((code 334) (verifier_name 30)
        (score_if_true
         ((bits_gained 0.71049338280501484) (probability 0.61111111111111116)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 334) (verifier_name 30)
      (condition ((index 1) (condition (Equal_value (symbol Square) (value 4)))))
      (result false) (remaining_bits_before 4.1699250014423122)
      (bits_gained 0.58496250072115608) (remaining_bits 3.5849625007211561)
      (number_of_remaining_codes 12)))
    (Request_test
     ((new_round false) (code 334) (verifier_name 33)
      (info
       ((code 334) (verifier_name 33)
        (score_if_true
         ((bits_gained 1.2630344058337939) (probability 0.41666666666666669)))
        (score_if_false
         ((bits_gained 0.7776075786635519) (probability 0.58333333333333337)))))))
    (Test_result
     ((code 334) (verifier_name 33)
      (condition ((index 0) (condition (Is_even (symbol Triangle)))))
      (result false) (remaining_bits_before 3.5849625007211561)
      (bits_gained 0.7776075786635519) (remaining_bits 2.8073549220576042)
      (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 121) (verifier_name 33)
      (info
       ((code 121) (verifier_name 33)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 121) (verifier_name 33)
      (condition ((index 0) (condition (Is_even (symbol Triangle)))))
      (result false) (remaining_bits_before 2.8073549220576042)
      (bits_gained 0.80735492205760417) (remaining_bits 2)
      (number_of_remaining_codes 4)))
    (Request_test
     ((new_round false) (code 121) (verifier_name 22)
      (info
       ((code 121) (verifier_name 22)
        (score_if_true ((bits_gained 0.41503749927884392) (probability 0.75)))
        (score_if_false ((bits_gained 2) (probability 0.25)))))))
    (Test_result
     ((code 121) (verifier_name 22)
      (condition ((index 0) (condition Are_increasing))) (result false)
      (remaining_bits_before 2) (bits_gained 2) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path
       ((rounds
         (((code 334) (verifiers (34 30 33))) ((code 121) (verifiers (33 22)))))))
      (cost ((number_of_rounds 2) (number_of_verifiers 5)))))
    (Propose_solution (code 245))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
    ((code 345)
     (verifiers
      (((verifier_name 11)
        (criteria ((index 0) (condition (Less_than (a Triangle) (b Square))))))
       ((verifier_name 22) (criteria ((index 0) (condition Are_increasing))))
       ((verifier_name 30)
        (criteria
         ((index 1) (condition (Equal_value (symbol Square) (value 4))))))
       ((verifier_name 33)
        (criteria ((index 1) (condition (Is_even (symbol Square))))))
       ((verifier_name 34)
        (criteria
         ((index 0)
          (condition (Is_smallest_or_equally_smallest (symbol Triangle))))))
       ((verifier_name 40)
        (criteria
         ((index 1) (condition (Equal_value (symbol Triangle) (value 3)))))))))
    (Info ((remaining_bits 4.8579809951275719) (number_of_remaining_codes 29)))
    (Request_test
     ((new_round true) (code 334) (verifier_name 34)
      (info
       ((code 334) (verifier_name 34)
        (score_if_true
         ((bits_gained 0.68805599368525971) (probability 0.62068965517241381)))
        (score_if_false
         ((bits_gained 0.85798099512757187) (probability 0.55172413793103448)))))))
    (Test_result
     ((code 334) (verifier_name 34)
      (condition
       ((index 0)
        (condition (Is_smallest_or_equally_smallest (symbol Triangle)))))
      (result true) (remaining_bits_before 4.8579809951275719)
      (bits_gained 0.68805599368525971) (remaining_bits 4.1699250014423122)
      (number_of_remaining_codes 18)))
    (Request_test
     ((new_round false) (code 334) (verifier_name 30)
      (info
       ((code 334) (verifier_name 30)
        (score_if_true
         ((bits_gained 0.71049338280501484) (probability 0.61111111111111116)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 334) (verifier_name 30)
      (condition ((index 1) (condition (Equal_value (symbol Square) (value 4)))))
      (result false) (remaining_bits_before 4.1699250014423122)
      (bits_gained 0.58496250072115608) (remaining_bits 3.5849625007211561)
      (number_of_remaining_codes 12)))
    (Request_test
     ((new_round false) (code 334) (verifier_name 33)
      (info
       ((code 334) (verifier_name 33)
        (score_if_true
         ((bits_gained 1.2630344058337939) (probability 0.41666666666666669)))
        (score_if_false
         ((bits_gained 0.7776075786635519) (probability 0.58333333333333337)))))))
    (Test_result
     ((code 334) (verifier_name 33)
      (condition ((index 1) (condition (Is_even (symbol Square)))))
      (result false) (remaining_bits_before 3.5849625007211561)
      (bits_gained 0.7776075786635519) (remaining_bits 2.8073549220576042)
      (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 121) (verifier_name 33)
      (info
       ((code 121) (verifier_name 33)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 121) (verifier_name 33)
      (condition ((index 1) (condition (Is_even (symbol Square))))) (result true)
      (remaining_bits_before 2.8073549220576042) (bits_gained 1.2223924213364481)
      (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3)))
    (Request_test
     ((new_round false) (code 121) (verifier_name 11)
      (info
       ((code 121) (verifier_name 11)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 121) (verifier_name 11)
      (condition ((index 0) (condition (Less_than (a Triangle) (b Square)))))
      (result true) (remaining_bits_before 1.5849625007211561)
      (bits_gained 1.5849625007211561) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path
       ((rounds
         (((code 334) (verifiers (34 30 33))) ((code 121) (verifiers (33 11)))))))
      (cost ((number_of_rounds 2) (number_of_verifiers 5)))))
    (Propose_solution (code 345))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
    ((code 234)
     (verifiers
      (((verifier_name 11)
        (criteria ((index 0) (condition (Less_than (a Triangle) (b Square))))))
       ((verifier_name 22) (criteria ((index 0) (condition Are_increasing))))
       ((verifier_name 30)
        (criteria
         ((index 2) (condition (Equal_value (symbol Circle) (value 4))))))
       ((verifier_name 33)
        (criteria ((index 0) (condition (Is_even (symbol Triangle))))))
       ((verifier_name 34)
        (criteria
         ((index 0)
          (condition (Is_smallest_or_equally_smallest (symbol Triangle))))))
       ((verifier_name 40)
        (criteria
         ((index 0) (condition (Less_than_value (symbol Triangle) (value 3)))))))))
    (Info ((remaining_bits 4.8579809951275719) (number_of_remaining_codes 29)))
    (Request_test
     ((new_round true) (code 334) (verifier_name 34)
      (info
       ((code 334) (verifier_name 34)
        (score_if_true
         ((bits_gained 0.68805599368525971) (probability 0.62068965517241381)))
        (score_if_false
         ((bits_gained 0.85798099512757187) (probability 0.55172413793103448)))))))
    (Test_result
     ((code 334) (verifier_name 34)
      (condition
       ((index 0)
        (condition (Is_smallest_or_equally_smallest (symbol Triangle)))))
      (result true) (remaining_bits_before 4.8579809951275719)
      (bits_gained 0.68805599368525971) (remaining_bits 4.1699250014423122)
      (number_of_remaining_codes 18)))
    (Request_test
     ((new_round false) (code 334) (verifier_name 30)
      (info
       ((code 334) (verifier_name 30)
        (score_if_true
         ((bits_gained 0.71049338280501484) (probability 0.61111111111111116)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 334) (verifier_name 30)
      (condition ((index 2) (condition (Equal_value (symbol Circle) (value 4)))))
      (result true) (remaining_bits_before 4.1699250014423122)
      (bits_gained 0.71049338280501484) (remaining_bits 3.4594316186372973)
      (number_of_remaining_codes 11)))
    (Request_test
     ((new_round false) (code 334) (verifier_name 40)
      (info
       ((code 334) (verifier_name 40)
        (score_if_true
         ((bits_gained 0.87446911791614124) (probability 0.54545454545454541)))
        (score_if_false
         ((bits_gained 0.65207669657969314) (probability 0.63636363636363635)))))))
    (Test_result
     ((code 334) (verifier_name 40)
      (condition
       ((index 0) (condition (Less_than_value (symbol Triangle) (value 3)))))
      (result false) (remaining_bits_before 3.4594316186372973)
      (bits_gained 0.65207669657969314) (remaining_bits 2.8073549220576042)
      (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 211) (verifier_name 40)
      (info
       ((code 211) (verifier_name 40)
        (score_if_true
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))
        (score_if_false
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))))))
    (Test_result
     ((code 211) (verifier_name 40)
      (condition
       ((index 0) (condition (Less_than_value (symbol Triangle) (value 3)))))
      (result true) (remaining_bits_before 2.8073549220576042)
      (bits_gained 0.80735492205760417) (remaining_bits 2)
      (number_of_remaining_codes 4)))
    (Request_test
     ((new_round false) (code 211) (verifier_name 22)
      (info
       ((code 211) (verifier_name 22)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 211) (verifier_name 22)
      (condition ((index 0) (condition Are_increasing))) (result false)
      (remaining_bits_before 2) (bits_gained 1) (remaining_bits 1)
      (number_of_remaining_codes 2)))
    (Request_test
     ((new_round false) (code 211) (verifier_name 33)
      (info
       ((code 211) (verifier_name 33)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 211) (verifier_name 33)
      (condition ((index 0) (condition (Is_even (symbol Triangle)))))
      (result true) (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path
       ((rounds
         (((code 334) (verifiers (34 30 40)))
          ((code 211) (verifiers (40 22 33)))))))
      (cost ((number_of_rounds 2) (number_of_verifiers 6)))))
    (Propose_solution (code 234))
    (Ok "Code match hypothesis expected code") |}];
  ()
;;
