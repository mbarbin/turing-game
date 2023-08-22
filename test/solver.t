Simulating an interactive resolution, as if the solution to the 1st problem was
543 (it doesn't matter what the actual solution is in the game).

  $ turing-game solver -verifiers 4,9,11,14 <<EOF
  > 
  > false
  > 
  > false
  > 
  > true
  > 
  (Info ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round true) (code 211) (verifier_index 9)
    (info
     ((code 211) (verifier_index 9)
      (score_if_true
       ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
      (score_if_false
       ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
  
  Enter result for test. code=211 - verifier=B(09): 
  (Test_result
   ((code 211) (verifier_letter B) (verifier_index 9) (condition Undetermined)
    (result false) (remaining_bits_before 2.8073549220576042)
    (bits_gained 0.80735492205760417) (remaining_bits 2)
    (number_of_remaining_codes 4)))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round false) (code 211) (verifier_index 4)
    (info
     ((code 211) (verifier_index 4)
      (score_if_true ((bits_gained 2) (probability 0.25)))
      (score_if_false ((bits_gained 0.41503749927884392) (probability 0.75)))))))
  
  Enter result for test. code=211 - verifier=A(04): 
  (Test_result
   ((code 211) (verifier_letter A) (verifier_index 4) (condition Undetermined)
    (result false) (remaining_bits_before 2) (bits_gained 0.41503749927884392)
    (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3)))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round false) (code 211) (verifier_index 11)
    (info
     ((code 211) (verifier_index 11)
      (score_if_true
       ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
      (score_if_false
       ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
  
  Enter result for test. code=211 - verifier=C(11): 
  (Test_result
   ((code 211) (verifier_letter C) (verifier_index 11)
    (condition
     ((index 2)
      (condition (Compare_symbols (a Triangle) (ordering Greater) (b Square)))))
    (result true) (remaining_bits_before 1.5849625007211561)
    (bits_gained 1.5849625007211561) (remaining_bits 0)
    (number_of_remaining_codes 1)))
  
  Ready to propose a solution. Type ENTER to continue...
  (Info
   ((resolution_path ((rounds (((code 211) (verifiers (9 4 11)))))))
    (cost ((number_of_rounds 1) (number_of_verifiers 3)))))
  (Propose_solution (code 543))
