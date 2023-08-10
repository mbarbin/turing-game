open! Core
open! Turing_game

let simulate_all_hypotheses ~decoder =
  let hypotheses = Decoder.hypotheses decoder in
  List.iter hypotheses ~f:(fun hypothesis ->
    print_endline "============= NEW HYPOTHESIS =============";
    print_s [%sexp (hypothesis : Decoder.Hypothesis.t)];
    let steps =
      Interactive_solver.simulate_resolution_for_hypothesis ~decoder ~hypothesis
    in
    print_s [%sexp (steps : Interactive_solver.Step.t list)])
;;

let%expect_test "interactive solver simulation decoder 1" =
  let decoder =
    Decoder.create
      ~verifiers:Verifier.Examples.[ verifier_04; verifier_09; verifier_11; verifier_14 ]
  in
  simulate_all_hypotheses ~decoder;
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

(*
   {[
     let%expect_test "interactive solver simulation decoder 20" =
       let decoder =
         Decoder.create
           ~verifiers:
             Verifier.Examples.
               [ verifier_11
               ; verifier_22
               ; verifier_30
               ; verifier_33
               ; verifier_34
               ; verifier_40
               ]
       in
       simulate_all_hypotheses ~decoder;
       [%expect {||}];
       ()
     ;;
   ]}
*)
