Simulating an interactive resolution, as if the solution to the 1st problem was
443 (it doesn't matter what the actual solution is in the game).

  $ turing-game solver 1 <<EOF
  > 
  > false
  > 
  > false
  > 
  > false
  > 
  > true
  > 
  ((remaining_bits 2.8073549220576042) (number_of_remaining_codes 7))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round true) (code 111) (verifier 09)
    (info
     ((code 111) (verifier 09)
      (score_if_true
       ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
      (score_if_false
       ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
  
  Enter result for test. code="111" - verifier="09": 
  (Test_result
   ((code 111) (verifier 09) (result false)
    (remaining_bits_before 2.8073549220576042)
    (bits_gained 0.80735492205760417) (remaining_bits 2)
    (number_of_remaining_codes 4)))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round false) (code 111) (verifier 11)
    (info
     ((code 111) (verifier 11)
      (score_if_true ((bits_gained 1) (probability 0.5)))
      (score_if_false ((bits_gained 1) (probability 0.5)))))))
  
  Enter result for test. code="111" - verifier="11": 
  (Test_result
   ((code 111) (verifier 11) (result false) (remaining_bits_before 2)
    (bits_gained 1) (remaining_bits 1) (number_of_remaining_codes 2)))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round false) (code 111) (verifier 04)
    (info
     ((code 111) (verifier 04)
      (score_if_true ((bits_gained 1) (probability 0.5)))
      (score_if_false ((bits_gained 1) (probability 0.5)))))))
  
  Enter result for test. code="111" - verifier="04": 
  (Test_result
   ((code 111) (verifier 04) (result false) (remaining_bits_before 1)
    (bits_gained 1) (remaining_bits 0) (number_of_remaining_codes 1)))
  
  Ready to propose a solution. Type ENTER to continue...
  ((resolution_path ((rounds (((code 111) (verifiers (09 11 04)))))))
   (cost ((number_of_rounds 1) (number_of_verifiers 3))))
  (Propose_solution (code 543))
