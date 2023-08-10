Simulating an interactive resolution to problem 2. As of now, this yields a
solution that uses 3 rounds vs only 2 when using the complete solver.

To be investigated whether it's possible to improve the choices made by the
interactive solver, or if this is an indication of a bug somewhere.

  $ turing-game complete-solver example -n 2 -quick
  ((parent_path ()) (parent_evaluation 13) (number_of_children 500))
  ((parent_path (((code 131) (verifiers (03 07 10))))) (parent_evaluation 3)
   (number_of_children 296))
  ((solutions
    (((rounds
       (((code 131) (verifiers (03 07 10)))
        ((code 214) (verifiers (03 10 14))))))))
   (number_of_solutions 1))

  $ turing-game solver 2 <<EOF
  > 
  > false
  > 
  > false
  > 
  > false
  > 
  > false
  > 
  > false
  > 
  > true
  > 
  > true
  > 
  ((remaining_bits 3.7004397181410922) (number_of_remaining_codes 13))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round true) (code 144) (verifier 10)
    (info
     ((code 144) (verifier 10)
      (score_if_true
       ((bits_gained 2.7004397181410922) (probability 0.15384615384615385)))
      (score_if_false
       ((bits_gained 0.24100809950379487) (probability 0.84615384615384615)))))))
  
  Enter result for test. code="144" - verifier="10": 
  (Test_result
   ((code 144) (verifier 10) (result false)
    (remaining_bits_before 3.7004397181410922)
    (bits_gained 0.24100809950379487) (remaining_bits 3.4594316186372973)
    (number_of_remaining_codes 11)))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round false) (code 144) (verifier 03)
    (info
     ((code 144) (verifier 03)
      (score_if_true
       ((bits_gained 2.4594316186372973) (probability 0.18181818181818182)))
      (score_if_false
       ((bits_gained 0.28950661719498516) (probability 0.81818181818181823)))))))
  
  Enter result for test. code="144" - verifier="03": 
  (Test_result
   ((code 144) (verifier 03) (result false)
    (remaining_bits_before 3.4594316186372973)
    (bits_gained 0.28950661719498516) (remaining_bits 3.1699250014423122)
    (number_of_remaining_codes 9)))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round false) (code 144) (verifier 14)
    (info
     ((code 144) (verifier 14)
      (score_if_true
       ((bits_gained 1.5849625007211561) (probability 0.33333333333333331)))
      (score_if_false
       ((bits_gained 0.58496250072115608) (probability 0.66666666666666663)))))))
  
  Enter result for test. code="144" - verifier="14": 
  (Test_result
   ((code 144) (verifier 14) (result false)
    (remaining_bits_before 3.1699250014423122)
    (bits_gained 0.58496250072115608) (remaining_bits 2.5849625007211561)
    (number_of_remaining_codes 6)))
  
  No more test to run with this code.
  Ready for next round. Type ENTER to continue...
  (Request_test
   ((new_round true) (code 111) (verifier 03)
    (info
     ((code 111) (verifier 03)
      (score_if_true
       ((bits_gained 2.5849625007211561) (probability 0.16666666666666666)))
      (score_if_false
       ((bits_gained 0.26303440583379389) (probability 0.83333333333333337)))))))
  
  Enter result for test. code="111" - verifier="03": 
  (Test_result
   ((code 111) (verifier 03) (result false)
    (remaining_bits_before 2.5849625007211561)
    (bits_gained 0.26303440583379389) (remaining_bits 2.3219280948873622)
    (number_of_remaining_codes 5)))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round false) (code 111) (verifier 10)
    (info
     ((code 111) (verifier 10)
      (score_if_true ((bits_gained 2.3219280948873622) (probability 0.2)))
      (score_if_false ((bits_gained 0.32192809488736218) (probability 0.8)))))))
  
  Enter result for test. code="111" - verifier="10": 
  (Test_result
   ((code 111) (verifier 10) (result false)
    (remaining_bits_before 2.3219280948873622)
    (bits_gained 0.32192809488736218) (remaining_bits 2)
    (number_of_remaining_codes 4)))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round false) (code 111) (verifier 07)
    (info
     ((code 111) (verifier 07)
      (score_if_true ((bits_gained 1) (probability 0.5)))
      (score_if_false ((bits_gained 1) (probability 0.5)))))))
  
  Enter result for test. code="111" - verifier="07": 
  (Test_result
   ((code 111) (verifier 07) (result true) (remaining_bits_before 2)
    (bits_gained 1) (remaining_bits 1) (number_of_remaining_codes 2)))
  
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
   ((code 212) (verifier 14) (result true) (remaining_bits_before 1)
    (bits_gained 1) (remaining_bits 0) (number_of_remaining_codes 1)))
  
  Ready to propose a solution. Type ENTER to continue...
  ((resolution_path
    ((rounds
      (((code 144) (verifiers (10 03 14))) ((code 111) (verifiers (03 10 07)))
       ((code 212) (verifiers (14)))))))
   (cost ((number_of_rounds 3) (number_of_verifiers 7))))
  (Propose_solution (code 435))
