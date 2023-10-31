let%expect_test "interactive solver simulation decoder 1" =
  let config = Config.load_exn () in
  let decoder = Config.decoder_exn config [ 4; 9; 11; 14 ] in
  Interactive_solver.simulate_hypotheses ~decoder ~which_hypotheses:All;
  [%expect
    {|
    ============= NEW HYPOTHESIS =============
    ((code 221)
     (verifiers
      (((verifier_index 4)
        (criteria
         ((index 0)
          (predicate
           (Compare_symbol_with_value (symbol Square) (ordering Less) (value 4))))))
       ((verifier_index 9)
        (criteria ((index 0) (predicate (Has_digit_count (digit 3) (count 0))))))
       ((verifier_index 11)
        (criteria
         ((index 1)
          (predicate (Compare_symbols (a Triangle) (ordering Equal) (b Square))))))
       ((verifier_index 14)
        (criteria
         ((index 2)
          (predicate
           (Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))
    (Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 211) (verifier_index 9)
      (info
       ((code 211) (verifier_index 9)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 211) (verifier_letter B) (verifier_index 9)
      (predicate ((index 0) (predicate (Has_digit_count (digit 3) (count 0)))))
      (result true) (remaining_bits_before 2.8073549220576042)
      (bits_gained 1.2223924213364481) (remaining_bits 1.5849625007211561)
      (number_of_remaining_codes 3)))
    (Request_test
     ((new_round false) (code 211) (verifier_index 4)
      (info
       ((code 211) (verifier_index 4)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 211) (verifier_letter A) (verifier_index 4)
      (predicate
       ((index 0)
        (predicate
         (Compare_symbol_with_value (symbol Square) (ordering Less) (value 4)))))
      (result true) (remaining_bits_before 1.5849625007211561)
      (bits_gained 1.5849625007211561) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path ((rounds (((code 211) (verifiers (9 4)))))))
      (cost ((number_of_rounds 1) (number_of_verifiers 2)))))
    (Propose_solution (code 221))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
    ((code 231)
     (verifiers
      (((verifier_index 4)
        (criteria
         ((index 0)
          (predicate
           (Compare_symbol_with_value (symbol Square) (ordering Less) (value 4))))))
       ((verifier_index 9)
        (criteria ((index 1) (predicate (Has_digit_count (digit 3) (count 1))))))
       ((verifier_index 11)
        (criteria
         ((index 0)
          (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square))))))
       ((verifier_index 14)
        (criteria
         ((index 2)
          (predicate
           (Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))
    (Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 211) (verifier_index 9)
      (info
       ((code 211) (verifier_index 9)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 211) (verifier_letter B) (verifier_index 9)
      (predicate ((index 1) (predicate (Has_digit_count (digit 3) (count 1)))))
      (result false) (remaining_bits_before 2.8073549220576042)
      (bits_gained 0.80735492205760417) (remaining_bits 2)
      (number_of_remaining_codes 4)))
    (Request_test
     ((new_round false) (code 211) (verifier_index 4)
      (info
       ((code 211) (verifier_index 4)
        (score_if_true ((bits_gained 2) (probability 0.25)))
        (score_if_false ((bits_gained 0.41503749927884392) (probability 0.75)))))))
    (Test_result
     ((code 211) (verifier_letter A) (verifier_index 4)
      (predicate
       ((index 0)
        (predicate
         (Compare_symbol_with_value (symbol Square) (ordering Less) (value 4)))))
      (result true) (remaining_bits_before 2) (bits_gained 2) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path ((rounds (((code 211) (verifiers (9 4)))))))
      (cost ((number_of_rounds 1) (number_of_verifiers 2)))))
    (Propose_solution (code 231))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
    ((code 241)
     (verifiers
      (((verifier_index 4)
        (criteria
         ((index 1)
          (predicate
           (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4))))))
       ((verifier_index 9)
        (criteria ((index 0) (predicate (Has_digit_count (digit 3) (count 0))))))
       ((verifier_index 11)
        (criteria
         ((index 0)
          (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square))))))
       ((verifier_index 14)
        (criteria
         ((index 2)
          (predicate
           (Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))
    (Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 211) (verifier_index 9)
      (info
       ((code 211) (verifier_index 9)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 211) (verifier_letter B) (verifier_index 9)
      (predicate ((index 0) (predicate (Has_digit_count (digit 3) (count 0)))))
      (result true) (remaining_bits_before 2.8073549220576042)
      (bits_gained 1.2223924213364481) (remaining_bits 1.5849625007211561)
      (number_of_remaining_codes 3)))
    (Request_test
     ((new_round false) (code 211) (verifier_index 4)
      (info
       ((code 211) (verifier_index 4)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 211) (verifier_letter A) (verifier_index 4)
      (predicate
       ((index 1)
        (predicate
         (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4)))))
      (result false) (remaining_bits_before 1.5849625007211561)
      (bits_gained 0.58496250072115608) (remaining_bits 1)
      (number_of_remaining_codes 2)))
    (Request_test
     ((new_round false) (code 211) (verifier_index 11)
      (info
       ((code 211) (verifier_index 11)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 211) (verifier_letter C) (verifier_index 11)
      (predicate
       ((index 0)
        (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square)))))
      (result false) (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path ((rounds (((code 211) (verifiers (9 4 11)))))))
      (cost ((number_of_rounds 1) (number_of_verifiers 3)))))
    (Propose_solution (code 241))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
    ((code 545)
     (verifiers
      (((verifier_index 4)
        (criteria
         ((index 1)
          (predicate
           (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4))))))
       ((verifier_index 9)
        (criteria ((index 0) (predicate (Has_digit_count (digit 3) (count 0))))))
       ((verifier_index 11)
        (criteria
         ((index 2)
          (predicate
           (Compare_symbols (a Triangle) (ordering Greater) (b Square))))))
       ((verifier_index 14)
        (criteria
         ((index 1)
          (predicate
           (Compare_symbol_with_others (symbol Square) (orderings (Less))))))))))
    (Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 211) (verifier_index 9)
      (info
       ((code 211) (verifier_index 9)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 211) (verifier_letter B) (verifier_index 9)
      (predicate ((index 0) (predicate (Has_digit_count (digit 3) (count 0)))))
      (result true) (remaining_bits_before 2.8073549220576042)
      (bits_gained 1.2223924213364481) (remaining_bits 1.5849625007211561)
      (number_of_remaining_codes 3)))
    (Request_test
     ((new_round false) (code 211) (verifier_index 4)
      (info
       ((code 211) (verifier_index 4)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 211) (verifier_letter A) (verifier_index 4)
      (predicate
       ((index 1)
        (predicate
         (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4)))))
      (result false) (remaining_bits_before 1.5849625007211561)
      (bits_gained 0.58496250072115608) (remaining_bits 1)
      (number_of_remaining_codes 2)))
    (Request_test
     ((new_round false) (code 211) (verifier_index 11)
      (info
       ((code 211) (verifier_index 11)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 211) (verifier_letter C) (verifier_index 11)
      (predicate
       ((index 2)
        (predicate (Compare_symbols (a Triangle) (ordering Greater) (b Square)))))
      (result true) (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path ((rounds (((code 211) (verifiers (9 4 11)))))))
      (cost ((number_of_rounds 1) (number_of_verifiers 3)))))
    (Propose_solution (code 545))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
    ((code 443)
     (verifiers
      (((verifier_index 4)
        (criteria
         ((index 1)
          (predicate
           (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4))))))
       ((verifier_index 9)
        (criteria ((index 1) (predicate (Has_digit_count (digit 3) (count 1))))))
       ((verifier_index 11)
        (criteria
         ((index 1)
          (predicate (Compare_symbols (a Triangle) (ordering Equal) (b Square))))))
       ((verifier_index 14)
        (criteria
         ((index 2)
          (predicate
           (Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))
    (Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 211) (verifier_index 9)
      (info
       ((code 211) (verifier_index 9)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 211) (verifier_letter B) (verifier_index 9)
      (predicate ((index 1) (predicate (Has_digit_count (digit 3) (count 1)))))
      (result false) (remaining_bits_before 2.8073549220576042)
      (bits_gained 0.80735492205760417) (remaining_bits 2)
      (number_of_remaining_codes 4)))
    (Request_test
     ((new_round false) (code 211) (verifier_index 4)
      (info
       ((code 211) (verifier_index 4)
        (score_if_true ((bits_gained 2) (probability 0.25)))
        (score_if_false ((bits_gained 0.41503749927884392) (probability 0.75)))))))
    (Test_result
     ((code 211) (verifier_letter A) (verifier_index 4)
      (predicate
       ((index 1)
        (predicate
         (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4)))))
      (result false) (remaining_bits_before 2) (bits_gained 0.41503749927884392)
      (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3)))
    (Request_test
     ((new_round false) (code 211) (verifier_index 11)
      (info
       ((code 211) (verifier_index 11)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 211) (verifier_letter C) (verifier_index 11)
      (predicate
       ((index 1)
        (predicate (Compare_symbols (a Triangle) (ordering Equal) (b Square)))))
      (result false) (remaining_bits_before 1.5849625007211561)
      (bits_gained 0.58496250072115608) (remaining_bits 1)
      (number_of_remaining_codes 2)))
    (Request_test
     ((new_round true) (code 141) (verifier_index 4)
      (info
       ((code 141) (verifier_index 4)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 141) (verifier_letter A) (verifier_index 4)
      (predicate
       ((index 1)
        (predicate
         (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4)))))
      (result true) (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path
       ((rounds (((code 211) (verifiers (9 4 11))) ((code 141) (verifiers (4)))))))
      (cost ((number_of_rounds 2) (number_of_verifiers 4)))))
    (Propose_solution (code 443))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
    ((code 543)
     (verifiers
      (((verifier_index 4)
        (criteria
         ((index 1)
          (predicate
           (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4))))))
       ((verifier_index 9)
        (criteria ((index 1) (predicate (Has_digit_count (digit 3) (count 1))))))
       ((verifier_index 11)
        (criteria
         ((index 2)
          (predicate
           (Compare_symbols (a Triangle) (ordering Greater) (b Square))))))
       ((verifier_index 14)
        (criteria
         ((index 2)
          (predicate
           (Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))
    (Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 211) (verifier_index 9)
      (info
       ((code 211) (verifier_index 9)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 211) (verifier_letter B) (verifier_index 9)
      (predicate ((index 1) (predicate (Has_digit_count (digit 3) (count 1)))))
      (result false) (remaining_bits_before 2.8073549220576042)
      (bits_gained 0.80735492205760417) (remaining_bits 2)
      (number_of_remaining_codes 4)))
    (Request_test
     ((new_round false) (code 211) (verifier_index 4)
      (info
       ((code 211) (verifier_index 4)
        (score_if_true ((bits_gained 2) (probability 0.25)))
        (score_if_false ((bits_gained 0.41503749927884392) (probability 0.75)))))))
    (Test_result
     ((code 211) (verifier_letter A) (verifier_index 4)
      (predicate
       ((index 1)
        (predicate
         (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4)))))
      (result false) (remaining_bits_before 2) (bits_gained 0.41503749927884392)
      (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3)))
    (Request_test
     ((new_round false) (code 211) (verifier_index 11)
      (info
       ((code 211) (verifier_index 11)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 211) (verifier_letter C) (verifier_index 11)
      (predicate
       ((index 2)
        (predicate (Compare_symbols (a Triangle) (ordering Greater) (b Square)))))
      (result true) (remaining_bits_before 1.5849625007211561)
      (bits_gained 1.5849625007211561) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path ((rounds (((code 211) (verifiers (9 4 11)))))))
      (cost ((number_of_rounds 1) (number_of_verifiers 3)))))
    (Propose_solution (code 543))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
    ((code 553)
     (verifiers
      (((verifier_index 4)
        (criteria
         ((index 2)
          (predicate
           (Compare_symbol_with_value (symbol Square) (ordering Greater)
            (value 4))))))
       ((verifier_index 9)
        (criteria ((index 1) (predicate (Has_digit_count (digit 3) (count 1))))))
       ((verifier_index 11)
        (criteria
         ((index 1)
          (predicate (Compare_symbols (a Triangle) (ordering Equal) (b Square))))))
       ((verifier_index 14)
        (criteria
         ((index 2)
          (predicate
           (Compare_symbol_with_others (symbol Circle) (orderings (Less))))))))))
    (Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
    (Request_test
     ((new_round true) (code 211) (verifier_index 9)
      (info
       ((code 211) (verifier_index 9)
        (score_if_true
         ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
        (score_if_false
         ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
    (Test_result
     ((code 211) (verifier_letter B) (verifier_index 9)
      (predicate ((index 1) (predicate (Has_digit_count (digit 3) (count 1)))))
      (result false) (remaining_bits_before 2.8073549220576042)
      (bits_gained 0.80735492205760417) (remaining_bits 2)
      (number_of_remaining_codes 4)))
    (Request_test
     ((new_round false) (code 211) (verifier_index 4)
      (info
       ((code 211) (verifier_index 4)
        (score_if_true ((bits_gained 2) (probability 0.25)))
        (score_if_false ((bits_gained 0.41503749927884392) (probability 0.75)))))))
    (Test_result
     ((code 211) (verifier_letter A) (verifier_index 4)
      (predicate
       ((index 2)
        (predicate
         (Compare_symbol_with_value (symbol Square) (ordering Greater) (value 4)))))
      (result false) (remaining_bits_before 2) (bits_gained 0.41503749927884392)
      (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3)))
    (Request_test
     ((new_round false) (code 211) (verifier_index 11)
      (info
       ((code 211) (verifier_index 11)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
        (score_if_false
         ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
    (Test_result
     ((code 211) (verifier_letter C) (verifier_index 11)
      (predicate
       ((index 1)
        (predicate (Compare_symbols (a Triangle) (ordering Equal) (b Square)))))
      (result false) (remaining_bits_before 1.5849625007211561)
      (bits_gained 0.58496250072115608) (remaining_bits 1)
      (number_of_remaining_codes 2)))
    (Request_test
     ((new_round true) (code 141) (verifier_index 4)
      (info
       ((code 141) (verifier_index 4)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 141) (verifier_letter A) (verifier_index 4)
      (predicate
       ((index 2)
        (predicate
         (Compare_symbol_with_value (symbol Square) (ordering Greater) (value 4)))))
      (result false) (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path
       ((rounds (((code 211) (verifiers (9 4 11))) ((code 141) (verifiers (4)))))))
      (cost ((number_of_rounds 2) (number_of_verifiers 4)))))
    (Propose_solution (code 553))
    (Ok "Code match hypothesis expected code") |}];
  ()
;;

let%expect_test "interactive solver simulation decoder 20" =
  let config = Config.load_exn () in
  let decoder = Config.decoder_exn config [ 11; 22; 30; 33; 34; 40 ] in
  Interactive_solver.simulate_hypotheses
    ~decoder
    ~which_hypotheses:(Only_the_first_n { n = 5 });
  [%expect
    {|
    ============= NEW HYPOTHESIS =============
    ((code 245)
     (verifiers
      (((verifier_index 11)
        (criteria
         ((index 0)
          (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square))))))
       ((verifier_index 22) (criteria ((index 0) (predicate Are_increasing))))
       ((verifier_index 30)
        (criteria
         ((index 1)
          (predicate
           (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4))))))
       ((verifier_index 33)
        (criteria ((index 0) (predicate (Is_even (symbol Triangle))))))
       ((verifier_index 34)
        (criteria
         ((index 0)
          (predicate
           (Compare_symbol_with_others (symbol Triangle)
            (orderings (Less Equal)))))))
       ((verifier_index 40)
        (criteria
         ((index 0)
          (predicate
           (Compare_symbol_with_value (symbol Triangle) (ordering Less)
            (value 3)))))))))
    (Info ((remaining_bits 5.4918530963296748) (number_of_remaining_codes 45)))
    (Request_test
     ((new_round true) (code 555) (verifier_index 11)
      (info
       ((code 555) (verifier_index 11)
        (score_if_true
         ((bits_gained 2.3219280948873626) (probability 0.42201834862385323)))
        (score_if_false
         ((bits_gained 0.32192809488736263) (probability 0.57798165137614688)))))))
    (Test_result
     ((code 555) (verifier_letter A) (verifier_index 11)
      (predicate
       ((index 0)
        (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square)))))
      (result false) (remaining_bits_before 5.4918530963296748)
      (bits_gained 0.32192809488736263) (remaining_bits 5.1699250014423122)
      (number_of_remaining_codes 36)))
    (Request_test
     ((new_round false) (code 555) (verifier_index 40)
      (info
       ((code 555) (verifier_index 40)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.46825396825396826)))
        (score_if_false
         ((bits_gained 0.21572869105543724) (probability 0.53174603174603174)))))))
    (Test_result
     ((code 555) (verifier_letter F) (verifier_index 40)
      (predicate
       ((index 0)
        (predicate
         (Compare_symbol_with_value (symbol Triangle) (ordering Less) (value 3)))))
      (result false) (remaining_bits_before 5.1699250014423122)
      (bits_gained 0.21572869105543724) (remaining_bits 4.9541963103868749)
      (number_of_remaining_codes 31)))
    (Request_test
     ((new_round false) (code 555) (verifier_index 22)
      (info
       ((code 555) (verifier_index 22)
        (score_if_true
         ((bits_gained 0.7062687969432897) (probability 0.64179104477611937)))
        (score_if_false
         ((bits_gained 1.3692338096657188) (probability 0.35820895522388058)))))))
    (Test_result
     ((code 555) (verifier_letter B) (verifier_index 22)
      (predicate ((index 0) (predicate Are_increasing))) (result false)
      (remaining_bits_before 4.9541963103868749) (bits_gained 1.3692338096657188)
      (remaining_bits 3.5849625007211561) (number_of_remaining_codes 12)))
    (Request_test
     ((new_round true) (code 141) (verifier_index 11)
      (info
       ((code 141) (verifier_index 11)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 141) (verifier_letter A) (verifier_index 11)
      (predicate
       ((index 0)
        (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square)))))
      (result true) (remaining_bits_before 3.5849625007211561) (bits_gained 1)
      (remaining_bits 2.5849625007211561) (number_of_remaining_codes 6)))
    (Request_test
     ((new_round false) (code 141) (verifier_index 30)
      (info
       ((code 141) (verifier_index 30)
        (score_if_true ((bits_gained 1) (probability 0.41666666666666669)))
        (score_if_false ((bits_gained 1) (probability 0.58333333333333337)))))))
    (Test_result
     ((code 141) (verifier_letter C) (verifier_index 30)
      (predicate
       ((index 1)
        (predicate
         (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4)))))
      (result true) (remaining_bits_before 2.5849625007211561) (bits_gained 1)
      (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3)))
    (Request_test
     ((new_round false) (code 141) (verifier_index 40)
      (info
       ((code 141) (verifier_index 40)
        (score_if_true ((bits_gained 0.58496250072115608) (probability 0.4)))
        (score_if_false ((bits_gained 1.5849625007211561) (probability 0.6)))))))
    (Test_result
     ((code 141) (verifier_letter F) (verifier_index 40)
      (predicate
       ((index 0)
        (predicate
         (Compare_symbol_with_value (symbol Triangle) (ordering Less) (value 3)))))
      (result true) (remaining_bits_before 1.5849625007211561)
      (bits_gained 0.58496250072115608) (remaining_bits 1)
      (number_of_remaining_codes 2)))
    (Request_test
     ((new_round true) (code 111) (verifier_index 33)
      (info
       ((code 111) (verifier_index 33)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 111) (verifier_letter D) (verifier_index 33)
      (predicate ((index 0) (predicate (Is_even (symbol Triangle)))))
      (result false) (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path
       ((rounds
         (((code 555) (verifiers (11 40 22))) ((code 141) (verifiers (11 30 40)))
          ((code 111) (verifiers (33)))))))
      (cost ((number_of_rounds 3) (number_of_verifiers 7)))))
    (Propose_solution (code 245))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
    ((code 245)
     (verifiers
      (((verifier_index 11)
        (criteria
         ((index 0)
          (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square))))))
       ((verifier_index 22) (criteria ((index 0) (predicate Are_increasing))))
       ((verifier_index 30)
        (criteria
         ((index 1)
          (predicate
           (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4))))))
       ((verifier_index 33)
        (criteria ((index 0) (predicate (Is_even (symbol Triangle))))))
       ((verifier_index 34)
        (criteria
         ((index 0)
          (predicate
           (Compare_symbol_with_others (symbol Triangle)
            (orderings (Less Equal)))))))
       ((verifier_index 40)
        (criteria
         ((index 5)
          (predicate
           (Compare_symbol_with_value (symbol Square) (ordering Greater)
            (value 3)))))))))
    (Info ((remaining_bits 5.4918530963296748) (number_of_remaining_codes 45)))
    (Request_test
     ((new_round true) (code 555) (verifier_index 11)
      (info
       ((code 555) (verifier_index 11)
        (score_if_true
         ((bits_gained 2.3219280948873626) (probability 0.42201834862385323)))
        (score_if_false
         ((bits_gained 0.32192809488736263) (probability 0.57798165137614688)))))))
    (Test_result
     ((code 555) (verifier_letter A) (verifier_index 11)
      (predicate
       ((index 0)
        (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square)))))
      (result false) (remaining_bits_before 5.4918530963296748)
      (bits_gained 0.32192809488736263) (remaining_bits 5.1699250014423122)
      (number_of_remaining_codes 36)))
    (Request_test
     ((new_round false) (code 555) (verifier_index 40)
      (info
       ((code 555) (verifier_index 40)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.46825396825396826)))
        (score_if_false
         ((bits_gained 0.21572869105543724) (probability 0.53174603174603174)))))))
    (Test_result
     ((code 555) (verifier_letter F) (verifier_index 40)
      (predicate
       ((index 5)
        (predicate
         (Compare_symbol_with_value (symbol Square) (ordering Greater) (value 3)))))
      (result true) (remaining_bits_before 5.1699250014423122)
      (bits_gained 1.5849625007211561) (remaining_bits 3.5849625007211561)
      (number_of_remaining_codes 12)))
    (Request_test
     ((new_round false) (code 555) (verifier_index 22)
      (info
       ((code 555) (verifier_index 22)
        (score_if_true ((bits_gained 1) (probability 0.864406779661017)))
        (score_if_false ((bits_gained 1) (probability 0.13559322033898305)))))))
    (Test_result
     ((code 555) (verifier_letter B) (verifier_index 22)
      (predicate ((index 0) (predicate Are_increasing))) (result false)
      (remaining_bits_before 3.5849625007211561) (bits_gained 1)
      (remaining_bits 2.5849625007211561) (number_of_remaining_codes 6)))
    (Request_test
     ((new_round true) (code 141) (verifier_index 30)
      (info
       ((code 141) (verifier_index 30)
        (score_if_true ((bits_gained 1.5849625007211561) (probability 0.5)))
        (score_if_false ((bits_gained 0.58496250072115608) (probability 0.5)))))))
    (Test_result
     ((code 141) (verifier_letter C) (verifier_index 30)
      (predicate
       ((index 1)
        (predicate
         (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4)))))
      (result true) (remaining_bits_before 2.5849625007211561)
      (bits_gained 1.5849625007211561) (remaining_bits 1)
      (number_of_remaining_codes 2)))
    (Request_test
     ((new_round false) (code 141) (verifier_index 11)
      (info
       ((code 141) (verifier_index 11)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 141) (verifier_letter A) (verifier_index 11)
      (predicate
       ((index 0)
        (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square)))))
      (result true) (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path
       ((rounds
         (((code 555) (verifiers (11 40 22))) ((code 141) (verifiers (30 11)))))))
      (cost ((number_of_rounds 2) (number_of_verifiers 5)))))
    (Propose_solution (code 245))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
    ((code 245)
     (verifiers
      (((verifier_index 11)
        (criteria
         ((index 0)
          (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square))))))
       ((verifier_index 22) (criteria ((index 0) (predicate Are_increasing))))
       ((verifier_index 30)
        (criteria
         ((index 1)
          (predicate
           (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4))))))
       ((verifier_index 33)
        (criteria ((index 0) (predicate (Is_even (symbol Triangle))))))
       ((verifier_index 34)
        (criteria
         ((index 0)
          (predicate
           (Compare_symbol_with_others (symbol Triangle)
            (orderings (Less Equal)))))))
       ((verifier_index 40)
        (criteria
         ((index 8)
          (predicate
           (Compare_symbol_with_value (symbol Circle) (ordering Greater)
            (value 3)))))))))
    (Info ((remaining_bits 5.4918530963296748) (number_of_remaining_codes 45)))
    (Request_test
     ((new_round true) (code 555) (verifier_index 11)
      (info
       ((code 555) (verifier_index 11)
        (score_if_true
         ((bits_gained 2.3219280948873626) (probability 0.42201834862385323)))
        (score_if_false
         ((bits_gained 0.32192809488736263) (probability 0.57798165137614688)))))))
    (Test_result
     ((code 555) (verifier_letter A) (verifier_index 11)
      (predicate
       ((index 0)
        (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square)))))
      (result false) (remaining_bits_before 5.4918530963296748)
      (bits_gained 0.32192809488736263) (remaining_bits 5.1699250014423122)
      (number_of_remaining_codes 36)))
    (Request_test
     ((new_round false) (code 555) (verifier_index 40)
      (info
       ((code 555) (verifier_index 40)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.46825396825396826)))
        (score_if_false
         ((bits_gained 0.21572869105543724) (probability 0.53174603174603174)))))))
    (Test_result
     ((code 555) (verifier_letter F) (verifier_index 40)
      (predicate
       ((index 8)
        (predicate
         (Compare_symbol_with_value (symbol Circle) (ordering Greater) (value 3)))))
      (result true) (remaining_bits_before 5.1699250014423122)
      (bits_gained 1.5849625007211561) (remaining_bits 3.5849625007211561)
      (number_of_remaining_codes 12)))
    (Request_test
     ((new_round false) (code 555) (verifier_index 22)
      (info
       ((code 555) (verifier_index 22)
        (score_if_true ((bits_gained 1) (probability 0.864406779661017)))
        (score_if_false ((bits_gained 1) (probability 0.13559322033898305)))))))
    (Test_result
     ((code 555) (verifier_letter B) (verifier_index 22)
      (predicate ((index 0) (predicate Are_increasing))) (result false)
      (remaining_bits_before 3.5849625007211561) (bits_gained 1)
      (remaining_bits 2.5849625007211561) (number_of_remaining_codes 6)))
    (Request_test
     ((new_round true) (code 141) (verifier_index 30)
      (info
       ((code 141) (verifier_index 30)
        (score_if_true ((bits_gained 1.5849625007211561) (probability 0.5)))
        (score_if_false ((bits_gained 0.58496250072115608) (probability 0.5)))))))
    (Test_result
     ((code 141) (verifier_letter C) (verifier_index 30)
      (predicate
       ((index 1)
        (predicate
         (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4)))))
      (result true) (remaining_bits_before 2.5849625007211561)
      (bits_gained 1.5849625007211561) (remaining_bits 1)
      (number_of_remaining_codes 2)))
    (Request_test
     ((new_round false) (code 141) (verifier_index 11)
      (info
       ((code 141) (verifier_index 11)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 141) (verifier_letter A) (verifier_index 11)
      (predicate
       ((index 0)
        (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square)))))
      (result true) (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path
       ((rounds
         (((code 555) (verifiers (11 40 22))) ((code 141) (verifiers (30 11)))))))
      (cost ((number_of_rounds 2) (number_of_verifiers 5)))))
    (Propose_solution (code 245))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
    ((code 145)
     (verifiers
      (((verifier_index 11)
        (criteria
         ((index 0)
          (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square))))))
       ((verifier_index 22) (criteria ((index 0) (predicate Are_increasing))))
       ((verifier_index 30)
        (criteria
         ((index 1)
          (predicate
           (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4))))))
       ((verifier_index 33)
        (criteria ((index 1) (predicate (Is_odd (symbol Triangle))))))
       ((verifier_index 34)
        (criteria
         ((index 0)
          (predicate
           (Compare_symbol_with_others (symbol Triangle)
            (orderings (Less Equal)))))))
       ((verifier_index 40)
        (criteria
         ((index 0)
          (predicate
           (Compare_symbol_with_value (symbol Triangle) (ordering Less)
            (value 3)))))))))
    (Info ((remaining_bits 5.4918530963296748) (number_of_remaining_codes 45)))
    (Request_test
     ((new_round true) (code 555) (verifier_index 11)
      (info
       ((code 555) (verifier_index 11)
        (score_if_true
         ((bits_gained 2.3219280948873626) (probability 0.42201834862385323)))
        (score_if_false
         ((bits_gained 0.32192809488736263) (probability 0.57798165137614688)))))))
    (Test_result
     ((code 555) (verifier_letter A) (verifier_index 11)
      (predicate
       ((index 0)
        (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square)))))
      (result false) (remaining_bits_before 5.4918530963296748)
      (bits_gained 0.32192809488736263) (remaining_bits 5.1699250014423122)
      (number_of_remaining_codes 36)))
    (Request_test
     ((new_round false) (code 555) (verifier_index 40)
      (info
       ((code 555) (verifier_index 40)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.46825396825396826)))
        (score_if_false
         ((bits_gained 0.21572869105543724) (probability 0.53174603174603174)))))))
    (Test_result
     ((code 555) (verifier_letter F) (verifier_index 40)
      (predicate
       ((index 0)
        (predicate
         (Compare_symbol_with_value (symbol Triangle) (ordering Less) (value 3)))))
      (result false) (remaining_bits_before 5.1699250014423122)
      (bits_gained 0.21572869105543724) (remaining_bits 4.9541963103868749)
      (number_of_remaining_codes 31)))
    (Request_test
     ((new_round false) (code 555) (verifier_index 22)
      (info
       ((code 555) (verifier_index 22)
        (score_if_true
         ((bits_gained 0.7062687969432897) (probability 0.64179104477611937)))
        (score_if_false
         ((bits_gained 1.3692338096657188) (probability 0.35820895522388058)))))))
    (Test_result
     ((code 555) (verifier_letter B) (verifier_index 22)
      (predicate ((index 0) (predicate Are_increasing))) (result false)
      (remaining_bits_before 4.9541963103868749) (bits_gained 1.3692338096657188)
      (remaining_bits 3.5849625007211561) (number_of_remaining_codes 12)))
    (Request_test
     ((new_round true) (code 141) (verifier_index 11)
      (info
       ((code 141) (verifier_index 11)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 141) (verifier_letter A) (verifier_index 11)
      (predicate
       ((index 0)
        (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square)))))
      (result true) (remaining_bits_before 3.5849625007211561) (bits_gained 1)
      (remaining_bits 2.5849625007211561) (number_of_remaining_codes 6)))
    (Request_test
     ((new_round false) (code 141) (verifier_index 30)
      (info
       ((code 141) (verifier_index 30)
        (score_if_true ((bits_gained 1) (probability 0.41666666666666669)))
        (score_if_false ((bits_gained 1) (probability 0.58333333333333337)))))))
    (Test_result
     ((code 141) (verifier_letter C) (verifier_index 30)
      (predicate
       ((index 1)
        (predicate
         (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4)))))
      (result true) (remaining_bits_before 2.5849625007211561) (bits_gained 1)
      (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3)))
    (Request_test
     ((new_round false) (code 141) (verifier_index 40)
      (info
       ((code 141) (verifier_index 40)
        (score_if_true ((bits_gained 0.58496250072115608) (probability 0.4)))
        (score_if_false ((bits_gained 1.5849625007211561) (probability 0.6)))))))
    (Test_result
     ((code 141) (verifier_letter F) (verifier_index 40)
      (predicate
       ((index 0)
        (predicate
         (Compare_symbol_with_value (symbol Triangle) (ordering Less) (value 3)))))
      (result true) (remaining_bits_before 1.5849625007211561)
      (bits_gained 0.58496250072115608) (remaining_bits 1)
      (number_of_remaining_codes 2)))
    (Request_test
     ((new_round true) (code 111) (verifier_index 33)
      (info
       ((code 111) (verifier_index 33)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 111) (verifier_letter D) (verifier_index 33)
      (predicate ((index 1) (predicate (Is_odd (symbol Triangle)))))
      (result true) (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path
       ((rounds
         (((code 555) (verifiers (11 40 22))) ((code 141) (verifiers (11 30 40)))
          ((code 111) (verifiers (33)))))))
      (cost ((number_of_rounds 3) (number_of_verifiers 7)))))
    (Propose_solution (code 145))
    (Ok "Code match hypothesis expected code")
    ============= NEW HYPOTHESIS =============
    ((code 345)
     (verifiers
      (((verifier_index 11)
        (criteria
         ((index 0)
          (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square))))))
       ((verifier_index 22) (criteria ((index 0) (predicate Are_increasing))))
       ((verifier_index 30)
        (criteria
         ((index 1)
          (predicate
           (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4))))))
       ((verifier_index 33)
        (criteria ((index 1) (predicate (Is_odd (symbol Triangle))))))
       ((verifier_index 34)
        (criteria
         ((index 0)
          (predicate
           (Compare_symbol_with_others (symbol Triangle)
            (orderings (Less Equal)))))))
       ((verifier_index 40)
        (criteria
         ((index 1)
          (predicate
           (Compare_symbol_with_value (symbol Triangle) (ordering Equal)
            (value 3)))))))))
    (Info ((remaining_bits 5.4918530963296748) (number_of_remaining_codes 45)))
    (Request_test
     ((new_round true) (code 555) (verifier_index 11)
      (info
       ((code 555) (verifier_index 11)
        (score_if_true
         ((bits_gained 2.3219280948873626) (probability 0.42201834862385323)))
        (score_if_false
         ((bits_gained 0.32192809488736263) (probability 0.57798165137614688)))))))
    (Test_result
     ((code 555) (verifier_letter A) (verifier_index 11)
      (predicate
       ((index 0)
        (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square)))))
      (result false) (remaining_bits_before 5.4918530963296748)
      (bits_gained 0.32192809488736263) (remaining_bits 5.1699250014423122)
      (number_of_remaining_codes 36)))
    (Request_test
     ((new_round false) (code 555) (verifier_index 40)
      (info
       ((code 555) (verifier_index 40)
        (score_if_true
         ((bits_gained 1.5849625007211561) (probability 0.46825396825396826)))
        (score_if_false
         ((bits_gained 0.21572869105543724) (probability 0.53174603174603174)))))))
    (Test_result
     ((code 555) (verifier_letter F) (verifier_index 40)
      (predicate
       ((index 1)
        (predicate
         (Compare_symbol_with_value (symbol Triangle) (ordering Equal) (value 3)))))
      (result false) (remaining_bits_before 5.1699250014423122)
      (bits_gained 0.21572869105543724) (remaining_bits 4.9541963103868749)
      (number_of_remaining_codes 31)))
    (Request_test
     ((new_round false) (code 555) (verifier_index 22)
      (info
       ((code 555) (verifier_index 22)
        (score_if_true
         ((bits_gained 0.7062687969432897) (probability 0.64179104477611937)))
        (score_if_false
         ((bits_gained 1.3692338096657188) (probability 0.35820895522388058)))))))
    (Test_result
     ((code 555) (verifier_letter B) (verifier_index 22)
      (predicate ((index 0) (predicate Are_increasing))) (result false)
      (remaining_bits_before 4.9541963103868749) (bits_gained 1.3692338096657188)
      (remaining_bits 3.5849625007211561) (number_of_remaining_codes 12)))
    (Request_test
     ((new_round true) (code 141) (verifier_index 11)
      (info
       ((code 141) (verifier_index 11)
        (score_if_true ((bits_gained 1) (probability 0.5)))
        (score_if_false ((bits_gained 1) (probability 0.5)))))))
    (Test_result
     ((code 141) (verifier_letter A) (verifier_index 11)
      (predicate
       ((index 0)
        (predicate (Compare_symbols (a Triangle) (ordering Less) (b Square)))))
      (result true) (remaining_bits_before 3.5849625007211561) (bits_gained 1)
      (remaining_bits 2.5849625007211561) (number_of_remaining_codes 6)))
    (Request_test
     ((new_round false) (code 141) (verifier_index 30)
      (info
       ((code 141) (verifier_index 30)
        (score_if_true ((bits_gained 1) (probability 0.41666666666666669)))
        (score_if_false ((bits_gained 1) (probability 0.58333333333333337)))))))
    (Test_result
     ((code 141) (verifier_letter C) (verifier_index 30)
      (predicate
       ((index 1)
        (predicate
         (Compare_symbol_with_value (symbol Square) (ordering Equal) (value 4)))))
      (result true) (remaining_bits_before 2.5849625007211561) (bits_gained 1)
      (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3)))
    (Request_test
     ((new_round false) (code 141) (verifier_index 40)
      (info
       ((code 141) (verifier_index 40)
        (score_if_true ((bits_gained 0.58496250072115608) (probability 0.4)))
        (score_if_false ((bits_gained 1.5849625007211561) (probability 0.6)))))))
    (Test_result
     ((code 141) (verifier_letter F) (verifier_index 40)
      (predicate
       ((index 1)
        (predicate
         (Compare_symbol_with_value (symbol Triangle) (ordering Equal) (value 3)))))
      (result false) (remaining_bits_before 1.5849625007211561)
      (bits_gained 1.5849625007211561) (remaining_bits 0)
      (number_of_remaining_codes 1)))
    (Info
     ((resolution_path
       ((rounds
         (((code 555) (verifiers (11 40 22)))
          ((code 141) (verifiers (11 30 40)))))))
      (cost ((number_of_rounds 2) (number_of_verifiers 6)))))
    (Propose_solution (code 345))
    (Ok "Code match hypothesis expected code") |}];
  ()
;;
