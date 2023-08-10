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
   ((new_round true) (code 114) (verifier 10)
    (info
     ((code 114) (verifier 10)
      (score_if_true
       ((bits_gained 0.893084796083488) (probability 0.53846153846153844)))
      (score_if_false
       ((bits_gained 1.1154772174199361) (probability 0.46153846153846156)))))))
  
  Enter result for test. code="114" - verifier="10": 
  (Test_result
   ((code 114) (verifier 10) (result false)
    (remaining_bits_before 3.7004397181410922) (bits_gained 1.1154772174199361)
    (remaining_bits 2.5849625007211561) (number_of_remaining_codes 6)))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round false) (code 114) (verifier 03)
    (info
     ((code 114) (verifier 03)
      (score_if_true
       ((bits_gained 2.5849625007211561) (probability 0.16666666666666666)))
      (score_if_false
       ((bits_gained 0.26303440583379389) (probability 0.83333333333333337)))))))
  
  Enter result for test. code="114" - verifier="03": 
  (Test_result
   ((code 114) (verifier 03) (result false)
    (remaining_bits_before 2.5849625007211561)
    (bits_gained 0.26303440583379389) (remaining_bits 2.3219280948873622)
    (number_of_remaining_codes 5)))
  
  Ready to request a new test. Type ENTER to continue...
  (Request_test
   ((new_round false) (code 114) (verifier 07)
    (info
     ((code 114) (verifier 07)
      (score_if_true ((bits_gained 0.32192809488736218) (probability 0.8)))
      (score_if_false ((bits_gained 2.3219280948873622) (probability 0.2)))))))
  
  Enter result for test. code="114" - verifier="07": 
  (Test_result
   ((code 114) (verifier 07) (result false)
    (remaining_bits_before 2.3219280948873622) (bits_gained 2.3219280948873622)
    (remaining_bits 0) (number_of_remaining_codes 1)))
  
  Ready to propose a solution. Type ENTER to continue...
  ((resolution_path ((rounds (((code 114) (verifiers (10 03 07)))))))
   (cost ((number_of_rounds 1) (number_of_verifiers 3))))
  (Propose_solution (code 535))
