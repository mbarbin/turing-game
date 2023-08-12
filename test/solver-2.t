Simulating an interactive resolution to problem 2.

  $ turing-game solver 2 <<EOF
  > 
  > true
  > 
  > true
  > 
  > false
  > 
  > true
  > 
  (Info ((remaining_bits 3.7004397181410922) (number_of_remaining_codes 13)))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round true) (code 231) (verifier 03)
    (info
     ((code 231) (verifier 03)
      (score_if_true
       ((bits_gained 0.893084796083488) (probability 0.53846153846153844)))
      (score_if_false
       ((bits_gained 1.1154772174199361) (probability 0.46153846153846156)))))))
  
  Enter result for test. code="231" - verifier="03": 
  (Test_result
   ((code 231) (verifier 03)
    (condition (Equal_value (symbol Square) (value 3))) (result true)
    (remaining_bits_before 3.7004397181410922) (bits_gained 0.893084796083488)
    (remaining_bits 2.8073549220576042) (number_of_remaining_codes 7)))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round false) (code 231) (verifier 07)
    (info
     ((code 231) (verifier 07)
      (score_if_true
       ((bits_gained 1.2223924213364481) (probability 0.42857142857142855)))
      (score_if_false
       ((bits_gained 0.80735492205760417) (probability 0.5714285714285714)))))))
  
  Enter result for test. code="231" - verifier="07": 
  (Test_result
   ((code 231) (verifier 07) (condition (Is_odd (symbol Circle))) (result true)
    (remaining_bits_before 2.8073549220576042) (bits_gained 1.2223924213364481)
    (remaining_bits 1.5849625007211561) (number_of_remaining_codes 3)))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round false) (code 231) (verifier 10)
    (info
     ((code 231) (verifier 10)
      (score_if_true
       ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
      (score_if_false
       ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
  
  Enter result for test. code="231" - verifier="10": 
  (Test_result
   ((code 231) (verifier 10) (condition Undetermined) (result false)
    (remaining_bits_before 1.5849625007211561)
    (bits_gained 0.58496250072115608) (remaining_bits 1)
    (number_of_remaining_codes 2)))
  
  No more test to run with this code.
  Ready for next round. Type ENTER to continue...
  (Request_test
   ((new_round true) (code 212) (verifier 14)
    (info
     ((code 212) (verifier 14)
      (score_if_true ((bits_gained 1) (probability 0.5)))
      (score_if_false ((bits_gained 1) (probability 0.5)))))))
  
  Enter result for test. code="212" - verifier="14": 
  (Test_result
   ((code 212) (verifier 14) (condition (Is_smallest (symbol Square)))
    (result true) (remaining_bits_before 1) (bits_gained 1) (remaining_bits 0)
    (number_of_remaining_codes 1)))
  
  Ready to propose a solution. Type ENTER to continue...
  (Info
   ((resolution_path
     ((rounds
       (((code 231) (verifiers (03 07 10))) ((code 212) (verifiers (14)))))))
    (cost ((number_of_rounds 2) (number_of_verifiers 4)))))
  (Propose_solution (code 435))
