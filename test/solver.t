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
   ((new_round true) (code 151) (verifier 04)
    (info
     ((code 151) (verifier 04)
      (score_if_true
       ((bits_gained 2.8073549220576042) (probability 0.14285714285714285)))
      (score_if_false
       ((bits_gained 0.2223924213364481) (probability 0.8571428571428571)))))))
  
  Enter result for test. code="151" - verifier="04": 
  (Test_result
   ((code 151) (verifier 04) (result false)
    (remaining_bits_before 2.8073549220576042) (bits_gained 0.2223924213364481)
    (remaining_bits 2.5849625007211561) (number_of_remaining_codes 6)))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round false) (code 151) (verifier 11)
    (info
     ((code 151) (verifier 11)
      (score_if_true
       ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
      (score_if_false
       ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
  
  Enter result for test. code="151" - verifier="11": 
  (Test_result
   ((code 151) (verifier 11) (result false)
    (remaining_bits_before 2.5849625007211561)
    (bits_gained 0.58496250072115608) (remaining_bits 2)
    (number_of_remaining_codes 4)))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round false) (code 151) (verifier 09)
    (info
     ((code 151) (verifier 09)
      (score_if_true ((bits_gained 1) (probability 0.5)))
      (score_if_false ((bits_gained 1) (probability 0.5)))))))
  
  Enter result for test. code="151" - verifier="09": 
  (Test_result
   ((code 151) (verifier 09) (result false) (remaining_bits_before 2)
    (bits_gained 1) (remaining_bits 1) (number_of_remaining_codes 2)))
  
  No more test to run with this code.
  Ready for next round. Type ENTER to continue...
  (Request_test
   ((new_round true) (code 111) (verifier 11)
    (info
     ((code 111) (verifier 11)
      (score_if_true ((bits_gained 1) (probability 0.5)))
      (score_if_false ((bits_gained 1) (probability 0.5)))))))
  
  Enter result for test. code="111" - verifier="11": 
  (Test_result
   ((code 111) (verifier 11) (result true) (remaining_bits_before 1)
    (bits_gained 1) (remaining_bits 0) (number_of_remaining_codes 1)))
  
  Ready to propose a solution. Type ENTER to continue...
  ((resolution_path
    ((rounds
      (((code 151) (verifiers (04 11 09))) ((code 111) (verifiers (11)))))))
   (cost ((number_of_rounds 2) (number_of_verifiers 4))))
  (Propose_solution (code 443))
