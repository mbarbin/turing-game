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
      ((new_round true) (code 151) (verifier 04)
       (info
        ((code 151) (verifier 04)
         (score_if_true
          ((bits_gained 2.8073549220576042) (probability 0.14285714285714285)))
         (score_if_false
          ((bits_gained 0.2223924213364481) (probability 0.8571428571428571)))))))
     (Info
      (Test_result
       ((code 151) (verifier 04)
        (condition (Less_than_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 0.2223924213364481) (remaining_bits 2.5849625007211561)
        (number_of_remaining_codes 6))))
     (Request_test
      ((new_round false) (code 151) (verifier 11)
       (info
        ((code 151) (verifier 11)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 151) (verifier 11) (condition (Equal (a Triangle) (b Square)))
        (result false) (remaining_bits_before 2.5849625007211561)
        (bits_gained 0.58496250072115608) (remaining_bits 2)
        (number_of_remaining_codes 4))))
     (Request_test
      ((new_round false) (code 151) (verifier 09)
       (info
        ((code 151) (verifier 09)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 151) (verifier 09)
        (condition (Has_digit_count (digit 3) (count 0))) (result true)
        (remaining_bits_before 2) (bits_gained 1) (remaining_bits 1)
        (number_of_remaining_codes 2))))
     (Request_test
      ((new_round true) (code 111) (verifier 04)
       (info
        ((code 111) (verifier 04)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 111) (verifier 04)
        (condition (Less_than_value (symbol Square) (value 4))) (result true)
        (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 221))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path
        ((rounds
          (((code 151) (verifiers (04 11 09))) ((code 111) (verifiers (04)))))))
       (cost ((number_of_rounds 2) (number_of_verifiers 4))))))
    ============= NEW HYPOTHESIS =============
    ((code 231)
     (verifiers
      (((name 04) (condition (Less_than_value (symbol Square) (value 4))))
       ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
       ((name 11) (condition (Less_than (a Triangle) (b Square))))
       ((name 14) (condition (Is_smallest (symbol Circle)))))))
    ((Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
     (Request_test
      ((new_round true) (code 151) (verifier 04)
       (info
        ((code 151) (verifier 04)
         (score_if_true
          ((bits_gained 2.8073549220576042) (probability 0.14285714285714285)))
         (score_if_false
          ((bits_gained 0.2223924213364481) (probability 0.8571428571428571)))))))
     (Info
      (Test_result
       ((code 151) (verifier 04)
        (condition (Less_than_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 0.2223924213364481) (remaining_bits 2.5849625007211561)
        (number_of_remaining_codes 6))))
     (Request_test
      ((new_round false) (code 151) (verifier 11)
       (info
        ((code 151) (verifier 11)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 151) (verifier 11) (condition (Less_than (a Triangle) (b Square)))
        (result true) (remaining_bits_before 2.5849625007211561)
        (bits_gained 1.5849625007211561) (remaining_bits 1)
        (number_of_remaining_codes 2))))
     (Request_test
      ((new_round false) (code 151) (verifier 09)
       (info
        ((code 151) (verifier 09)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 151) (verifier 09)
        (condition (Has_digit_count (digit 3) (count 1))) (result false)
        (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 231))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path ((rounds (((code 151) (verifiers (04 11 09)))))))
       (cost ((number_of_rounds 1) (number_of_verifiers 3))))))
    ============= NEW HYPOTHESIS =============
    ((code 241)
     (verifiers
      (((name 04) (condition (Equal_value (symbol Square) (value 4))))
       ((name 09) (condition (Has_digit_count (digit 3) (count 0))))
       ((name 11) (condition (Less_than (a Triangle) (b Square))))
       ((name 14) (condition (Is_smallest (symbol Circle)))))))
    ((Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
     (Request_test
      ((new_round true) (code 151) (verifier 04)
       (info
        ((code 151) (verifier 04)
         (score_if_true
          ((bits_gained 2.8073549220576042) (probability 0.14285714285714285)))
         (score_if_false
          ((bits_gained 0.2223924213364481) (probability 0.8571428571428571)))))))
     (Info
      (Test_result
       ((code 151) (verifier 04)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 0.2223924213364481) (remaining_bits 2.5849625007211561)
        (number_of_remaining_codes 6))))
     (Request_test
      ((new_round false) (code 151) (verifier 11)
       (info
        ((code 151) (verifier 11)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 151) (verifier 11) (condition (Less_than (a Triangle) (b Square)))
        (result true) (remaining_bits_before 2.5849625007211561)
        (bits_gained 1.5849625007211561) (remaining_bits 1)
        (number_of_remaining_codes 2))))
     (Request_test
      ((new_round false) (code 151) (verifier 09)
       (info
        ((code 151) (verifier 09)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 151) (verifier 09)
        (condition (Has_digit_count (digit 3) (count 0))) (result true)
        (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 241))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path ((rounds (((code 151) (verifiers (04 11 09)))))))
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
      ((new_round true) (code 151) (verifier 04)
       (info
        ((code 151) (verifier 04)
         (score_if_true
          ((bits_gained 2.8073549220576042) (probability 0.14285714285714285)))
         (score_if_false
          ((bits_gained 0.2223924213364481) (probability 0.8571428571428571)))))))
     (Info
      (Test_result
       ((code 151) (verifier 04)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 0.2223924213364481) (remaining_bits 2.5849625007211561)
        (number_of_remaining_codes 6))))
     (Request_test
      ((new_round false) (code 151) (verifier 11)
       (info
        ((code 151) (verifier 11)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 151) (verifier 11)
        (condition (Greater_than (a Triangle) (b Square))) (result false)
        (remaining_bits_before 2.5849625007211561)
        (bits_gained 0.58496250072115608) (remaining_bits 2)
        (number_of_remaining_codes 4))))
     (Request_test
      ((new_round false) (code 151) (verifier 09)
       (info
        ((code 151) (verifier 09)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 151) (verifier 09)
        (condition (Has_digit_count (digit 3) (count 0))) (result true)
        (remaining_bits_before 2) (bits_gained 1) (remaining_bits 1)
        (number_of_remaining_codes 2))))
     (Request_test
      ((new_round true) (code 111) (verifier 04)
       (info
        ((code 111) (verifier 04)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 111) (verifier 04)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 545))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path
        ((rounds
          (((code 151) (verifiers (04 11 09))) ((code 111) (verifiers (04)))))))
       (cost ((number_of_rounds 2) (number_of_verifiers 4))))))
    ============= NEW HYPOTHESIS =============
    ((code 443)
     (verifiers
      (((name 04) (condition (Equal_value (symbol Square) (value 4))))
       ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
       ((name 11) (condition (Equal (a Triangle) (b Square))))
       ((name 14) (condition (Is_smallest (symbol Circle)))))))
    ((Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
     (Request_test
      ((new_round true) (code 151) (verifier 04)
       (info
        ((code 151) (verifier 04)
         (score_if_true
          ((bits_gained 2.8073549220576042) (probability 0.14285714285714285)))
         (score_if_false
          ((bits_gained 0.2223924213364481) (probability 0.8571428571428571)))))))
     (Info
      (Test_result
       ((code 151) (verifier 04)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 0.2223924213364481) (remaining_bits 2.5849625007211561)
        (number_of_remaining_codes 6))))
     (Request_test
      ((new_round false) (code 151) (verifier 11)
       (info
        ((code 151) (verifier 11)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 151) (verifier 11) (condition (Equal (a Triangle) (b Square)))
        (result false) (remaining_bits_before 2.5849625007211561)
        (bits_gained 0.58496250072115608) (remaining_bits 2)
        (number_of_remaining_codes 4))))
     (Request_test
      ((new_round false) (code 151) (verifier 09)
       (info
        ((code 151) (verifier 09)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 151) (verifier 09)
        (condition (Has_digit_count (digit 3) (count 1))) (result false)
        (remaining_bits_before 2) (bits_gained 1) (remaining_bits 1)
        (number_of_remaining_codes 2))))
     (Request_test
      ((new_round true) (code 111) (verifier 11)
       (info
        ((code 111) (verifier 11)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 111) (verifier 11) (condition (Equal (a Triangle) (b Square)))
        (result true) (remaining_bits_before 1) (bits_gained 1)
        (remaining_bits 0) (number_of_remaining_codes 1))))
     (Propose_solution (code 443))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path
        ((rounds
          (((code 151) (verifiers (04 11 09))) ((code 111) (verifiers (11)))))))
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
      ((new_round true) (code 151) (verifier 04)
       (info
        ((code 151) (verifier 04)
         (score_if_true
          ((bits_gained 2.8073549220576042) (probability 0.14285714285714285)))
         (score_if_false
          ((bits_gained 0.2223924213364481) (probability 0.8571428571428571)))))))
     (Info
      (Test_result
       ((code 151) (verifier 04)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 0.2223924213364481) (remaining_bits 2.5849625007211561)
        (number_of_remaining_codes 6))))
     (Request_test
      ((new_round false) (code 151) (verifier 11)
       (info
        ((code 151) (verifier 11)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 151) (verifier 11)
        (condition (Greater_than (a Triangle) (b Square))) (result false)
        (remaining_bits_before 2.5849625007211561)
        (bits_gained 0.58496250072115608) (remaining_bits 2)
        (number_of_remaining_codes 4))))
     (Request_test
      ((new_round false) (code 151) (verifier 09)
       (info
        ((code 151) (verifier 09)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 151) (verifier 09)
        (condition (Has_digit_count (digit 3) (count 1))) (result false)
        (remaining_bits_before 2) (bits_gained 1) (remaining_bits 1)
        (number_of_remaining_codes 2))))
     (Request_test
      ((new_round true) (code 111) (verifier 11)
       (info
        ((code 111) (verifier 11)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 111) (verifier 11)
        (condition (Greater_than (a Triangle) (b Square))) (result false)
        (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 543))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path
        ((rounds
          (((code 151) (verifiers (04 11 09))) ((code 111) (verifiers (11)))))))
       (cost ((number_of_rounds 2) (number_of_verifiers 4))))))
    ============= NEW HYPOTHESIS =============
    ((code 553)
     (verifiers
      (((name 04) (condition (Greater_than_value (symbol Square) (value 4))))
       ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
       ((name 11) (condition (Equal (a Triangle) (b Square))))
       ((name 14) (condition (Is_smallest (symbol Circle)))))))
    ((Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
     (Request_test
      ((new_round true) (code 151) (verifier 04)
       (info
        ((code 151) (verifier 04)
         (score_if_true
          ((bits_gained 2.8073549220576042) (probability 0.14285714285714285)))
         (score_if_false
          ((bits_gained 0.2223924213364481) (probability 0.8571428571428571)))))))
     (Info
      (Test_result
       ((code 151) (verifier 04)
        (condition (Greater_than_value (symbol Square) (value 4))) (result true)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 2.8073549220576042) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 553))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path ((rounds (((code 151) (verifiers (04)))))))
       (cost ((number_of_rounds 1) (number_of_verifiers 1)))))) |}];
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
    ((Info ((remaining_bits 7.03342300153745) (number_of_remaining_codes 131)))
     (Request_test
      ((new_round true) (code 123) (verifier 22)
       (info
        ((code 123) (verifier 22)
         (score_if_true
          ((bits_gained 3.5739913829001528) (probability 0.083969465648854963)))
         (score_if_false
          ((bits_gained 0.12653240592893145) (probability 0.916030534351145)))))))
     (Info
      (Test_result
       ((code 123) (verifier 22) (condition Are_increasing) (result true)
        (remaining_bits_before 7.03342300153745) (bits_gained 3.5739913829001528)
        (remaining_bits 3.4594316186372973) (number_of_remaining_codes 11))))
     (Request_test
      ((new_round false) (code 123) (verifier 33)
       (info
        ((code 123) (verifier 33)
         (score_if_true
          ((bits_gained 1.4594316186372973) (probability 0.36363636363636365)))
         (score_if_false
          ((bits_gained 0.65207669657969314) (probability 0.63636363636363635)))))))
     (Info
      (Test_result
       ((code 123) (verifier 33) (condition (Is_even (symbol Triangle)))
        (result false) (remaining_bits_before 3.4594316186372973)
        (bits_gained 0.65207669657969314) (remaining_bits 2.8073549220576042)
        (number_of_remaining_codes 7))))
     (Request_test
      ((new_round false) (code 123) (verifier 40)
       (info
        ((code 123) (verifier 40)
         (score_if_true
          ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
         (score_if_false
          ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
     (Info
      (Test_result
       ((code 123) (verifier 40)
        (condition (Less_than_value (symbol Triangle) (value 3))) (result true)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 1.2223924213364481) (remaining_bits 1.5849625007211561)
        (number_of_remaining_codes 3))))
     (Request_test
      ((new_round true) (code 112) (verifier 33)
       (info
        ((code 112) (verifier 33)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 112) (verifier 33) (condition (Is_even (symbol Triangle)))
        (result false) (remaining_bits_before 1.5849625007211561)
        (bits_gained 0.58496250072115608) (remaining_bits 1)
        (number_of_remaining_codes 2))))
     (Request_test
      ((new_round true) (code 114) (verifier 30)
       (info
        ((code 114) (verifier 30)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 114) (verifier 30)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 245))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path
        ((rounds
          (((code 123) (verifiers (22 33 40))) ((code 112) (verifiers (33)))
           ((code 114) (verifiers (30)))))))
       (cost ((number_of_rounds 3) (number_of_verifiers 5))))))
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
    ((Info ((remaining_bits 7.03342300153745) (number_of_remaining_codes 131)))
     (Request_test
      ((new_round true) (code 123) (verifier 22)
       (info
        ((code 123) (verifier 22)
         (score_if_true
          ((bits_gained 3.5739913829001528) (probability 0.083969465648854963)))
         (score_if_false
          ((bits_gained 0.12653240592893145) (probability 0.916030534351145)))))))
     (Info
      (Test_result
       ((code 123) (verifier 22) (condition Are_increasing) (result true)
        (remaining_bits_before 7.03342300153745) (bits_gained 3.5739913829001528)
        (remaining_bits 3.4594316186372973) (number_of_remaining_codes 11))))
     (Request_test
      ((new_round false) (code 123) (verifier 33)
       (info
        ((code 123) (verifier 33)
         (score_if_true
          ((bits_gained 1.4594316186372973) (probability 0.36363636363636365)))
         (score_if_false
          ((bits_gained 0.65207669657969314) (probability 0.63636363636363635)))))))
     (Info
      (Test_result
       ((code 123) (verifier 33) (condition (Is_even (symbol Triangle)))
        (result false) (remaining_bits_before 3.4594316186372973)
        (bits_gained 0.65207669657969314) (remaining_bits 2.8073549220576042)
        (number_of_remaining_codes 7))))
     (Request_test
      ((new_round false) (code 123) (verifier 40)
       (info
        ((code 123) (verifier 40)
         (score_if_true
          ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
         (score_if_false
          ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
     (Info
      (Test_result
       ((code 123) (verifier 40)
        (condition (Greater_than_value (symbol Square) (value 3))) (result false)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 0.80735492205760417) (remaining_bits 2)
        (number_of_remaining_codes 4))))
     (Request_test
      ((new_round true) (code 131) (verifier 40)
       (info
        ((code 131) (verifier 40)
         (score_if_true ((bits_gained 2) (probability 0.25)))
         (score_if_false ((bits_gained 0.41503749927884392) (probability 0.75)))))))
     (Info
      (Test_result
       ((code 131) (verifier 40)
        (condition (Greater_than_value (symbol Square) (value 3))) (result false)
        (remaining_bits_before 2) (bits_gained 0.41503749927884392)
        (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3))))
     (Request_test
      ((new_round true) (code 114) (verifier 30)
       (info
        ((code 114) (verifier 30)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 114) (verifier 30)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 1.5849625007211561)
        (bits_gained 0.58496250072115608) (remaining_bits 1)
        (number_of_remaining_codes 2))))
     (Request_test
      ((new_round false) (code 114) (verifier 40)
       (info
        ((code 114) (verifier 40)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 114) (verifier 40)
        (condition (Greater_than_value (symbol Square) (value 3))) (result false)
        (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 245))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path
        ((rounds
          (((code 123) (verifiers (22 33 40))) ((code 131) (verifiers (40)))
           ((code 114) (verifiers (30 40)))))))
       (cost ((number_of_rounds 3) (number_of_verifiers 6))))))
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
    ((Info ((remaining_bits 7.03342300153745) (number_of_remaining_codes 131)))
     (Request_test
      ((new_round true) (code 123) (verifier 22)
       (info
        ((code 123) (verifier 22)
         (score_if_true
          ((bits_gained 3.5739913829001528) (probability 0.083969465648854963)))
         (score_if_false
          ((bits_gained 0.12653240592893145) (probability 0.916030534351145)))))))
     (Info
      (Test_result
       ((code 123) (verifier 22) (condition Are_increasing) (result true)
        (remaining_bits_before 7.03342300153745) (bits_gained 3.5739913829001528)
        (remaining_bits 3.4594316186372973) (number_of_remaining_codes 11))))
     (Request_test
      ((new_round false) (code 123) (verifier 33)
       (info
        ((code 123) (verifier 33)
         (score_if_true
          ((bits_gained 1.4594316186372973) (probability 0.36363636363636365)))
         (score_if_false
          ((bits_gained 0.65207669657969314) (probability 0.63636363636363635)))))))
     (Info
      (Test_result
       ((code 123) (verifier 33) (condition (Is_even (symbol Triangle)))
        (result false) (remaining_bits_before 3.4594316186372973)
        (bits_gained 0.65207669657969314) (remaining_bits 2.8073549220576042)
        (number_of_remaining_codes 7))))
     (Request_test
      ((new_round false) (code 123) (verifier 40)
       (info
        ((code 123) (verifier 40)
         (score_if_true
          ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
         (score_if_false
          ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
     (Info
      (Test_result
       ((code 123) (verifier 40)
        (condition (Greater_than_value (symbol Circle) (value 3))) (result false)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 0.80735492205760417) (remaining_bits 2)
        (number_of_remaining_codes 4))))
     (Request_test
      ((new_round true) (code 131) (verifier 40)
       (info
        ((code 131) (verifier 40)
         (score_if_true ((bits_gained 2) (probability 0.25)))
         (score_if_false ((bits_gained 0.41503749927884392) (probability 0.75)))))))
     (Info
      (Test_result
       ((code 131) (verifier 40)
        (condition (Greater_than_value (symbol Circle) (value 3))) (result false)
        (remaining_bits_before 2) (bits_gained 0.41503749927884392)
        (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3))))
     (Request_test
      ((new_round true) (code 114) (verifier 30)
       (info
        ((code 114) (verifier 30)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 114) (verifier 30)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 1.5849625007211561)
        (bits_gained 0.58496250072115608) (remaining_bits 1)
        (number_of_remaining_codes 2))))
     (Request_test
      ((new_round false) (code 114) (verifier 40)
       (info
        ((code 114) (verifier 40)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 114) (verifier 40)
        (condition (Greater_than_value (symbol Circle) (value 3))) (result true)
        (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 245))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path
        ((rounds
          (((code 123) (verifiers (22 33 40))) ((code 131) (verifiers (40)))
           ((code 114) (verifiers (30 40)))))))
       (cost ((number_of_rounds 3) (number_of_verifiers 6))))))
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
    ((Info ((remaining_bits 7.03342300153745) (number_of_remaining_codes 131)))
     (Request_test
      ((new_round true) (code 123) (verifier 22)
       (info
        ((code 123) (verifier 22)
         (score_if_true
          ((bits_gained 3.5739913829001528) (probability 0.083969465648854963)))
         (score_if_false
          ((bits_gained 0.12653240592893145) (probability 0.916030534351145)))))))
     (Info
      (Test_result
       ((code 123) (verifier 22) (condition Are_increasing) (result true)
        (remaining_bits_before 7.03342300153745) (bits_gained 3.5739913829001528)
        (remaining_bits 3.4594316186372973) (number_of_remaining_codes 11))))
     (Request_test
      ((new_round false) (code 123) (verifier 33)
       (info
        ((code 123) (verifier 33)
         (score_if_true
          ((bits_gained 1.4594316186372973) (probability 0.36363636363636365)))
         (score_if_false
          ((bits_gained 0.65207669657969314) (probability 0.63636363636363635)))))))
     (Info
      (Test_result
       ((code 123) (verifier 33) (condition (Is_even (symbol Square)))
        (result true) (remaining_bits_before 3.4594316186372973)
        (bits_gained 1.4594316186372973) (remaining_bits 2)
        (number_of_remaining_codes 4))))
     (Request_test
      ((new_round false) (code 123) (verifier 40)
       (info
        ((code 123) (verifier 40)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 123) (verifier 40)
        (condition (Equal_value (symbol Triangle) (value 3))) (result false)
        (remaining_bits_before 2) (bits_gained 1) (remaining_bits 1)
        (number_of_remaining_codes 2))))
     (Request_test
      ((new_round true) (code 114) (verifier 30)
       (info
        ((code 114) (verifier 30)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 114) (verifier 30)
        (condition (Equal_value (symbol Square) (value 4))) (result false)
        (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 345))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path
        ((rounds
          (((code 123) (verifiers (22 33 40))) ((code 114) (verifiers (30)))))))
       (cost ((number_of_rounds 2) (number_of_verifiers 4))))))
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
    ((Info ((remaining_bits 7.03342300153745) (number_of_remaining_codes 131)))
     (Request_test
      ((new_round true) (code 123) (verifier 22)
       (info
        ((code 123) (verifier 22)
         (score_if_true
          ((bits_gained 3.5739913829001528) (probability 0.083969465648854963)))
         (score_if_false
          ((bits_gained 0.12653240592893145) (probability 0.916030534351145)))))))
     (Info
      (Test_result
       ((code 123) (verifier 22) (condition Are_increasing) (result true)
        (remaining_bits_before 7.03342300153745) (bits_gained 3.5739913829001528)
        (remaining_bits 3.4594316186372973) (number_of_remaining_codes 11))))
     (Request_test
      ((new_round false) (code 123) (verifier 33)
       (info
        ((code 123) (verifier 33)
         (score_if_true
          ((bits_gained 1.4594316186372973) (probability 0.36363636363636365)))
         (score_if_false
          ((bits_gained 0.65207669657969314) (probability 0.63636363636363635)))))))
     (Info
      (Test_result
       ((code 123) (verifier 33) (condition (Is_even (symbol Triangle)))
        (result false) (remaining_bits_before 3.4594316186372973)
        (bits_gained 0.65207669657969314) (remaining_bits 2.8073549220576042)
        (number_of_remaining_codes 7))))
     (Request_test
      ((new_round false) (code 123) (verifier 40)
       (info
        ((code 123) (verifier 40)
         (score_if_true
          ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
         (score_if_false
          ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
     (Info
      (Test_result
       ((code 123) (verifier 40)
        (condition (Less_than_value (symbol Triangle) (value 3))) (result true)
        (remaining_bits_before 2.8073549220576042)
        (bits_gained 1.2223924213364481) (remaining_bits 1.5849625007211561)
        (number_of_remaining_codes 3))))
     (Request_test
      ((new_round true) (code 112) (verifier 33)
       (info
        ((code 112) (verifier 33)
         (score_if_true
          ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
         (score_if_false
          ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
     (Info
      (Test_result
       ((code 112) (verifier 33) (condition (Is_even (symbol Triangle)))
        (result false) (remaining_bits_before 1.5849625007211561)
        (bits_gained 0.58496250072115608) (remaining_bits 1)
        (number_of_remaining_codes 2))))
     (Request_test
      ((new_round true) (code 114) (verifier 30)
       (info
        ((code 114) (verifier 30)
         (score_if_true ((bits_gained 1) (probability 0.5)))
         (score_if_false ((bits_gained 1) (probability 0.5)))))))
     (Info
      (Test_result
       ((code 114) (verifier 30)
        (condition (Equal_value (symbol Circle) (value 4))) (result true)
        (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
        (number_of_remaining_codes 1))))
     (Propose_solution (code 234))
     (Info (Ok "Code match hypothesis expected code"))
     (Info
      ((resolution_path
        ((rounds
          (((code 123) (verifiers (22 33 40))) ((code 112) (verifiers (33)))
           ((code 114) (verifiers (30)))))))
       (cost ((number_of_rounds 3) (number_of_verifiers 5)))))) |}];
  ()
;;
