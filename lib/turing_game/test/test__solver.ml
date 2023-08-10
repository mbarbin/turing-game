open! Core
open! Turing_game

let verifier_04 = Test__decoder.verifier_04
let verifier_09 = Test__decoder.verifier_09
let verifier_11 = Test__decoder.verifier_11
let verifier_14 = Test__decoder.verifier_14

let decoder =
  Decoder.create ~verifiers:[ verifier_04; verifier_09; verifier_11; verifier_14 ]
;;

let print_is_complete ~resolution_path =
  print_s
    [%sexp
      { is_complete =
          (Solver.is_complete_resolution_path_with_trace ~decoder ~resolution_path
            : Solver.Is_complete_result.t)
      }]
;;

let print_max_number_of_remaining_codes ~resolution_path =
  let max_number_of_remaining_codes =
    Solver.max_number_of_remaining_codes ~decoder ~resolution_path
  in
  print_s [%sexp { max_number_of_remaining_codes : int }]
;;

let%expect_test "incomplete resolution_path" =
  let resolution_path =
    { Resolution_path.rounds =
        [ { code = { triangle = One; square = Four; circle = Three }
          ; verifiers = [ verifier_09.name ]
          }
        ; { code = { triangle = Two; square = One; circle = Five }
          ; verifiers = [ verifier_04.name ]
          }
        ]
    }
  in
  print_is_complete ~resolution_path;
  [%expect
    {|
    ((is_complete
      (No_with_counter_example
       ((results
         (((code 143) (verifier 09) (result false))
          ((code 215) (verifier 04) (result false))))
        (hypotheses
         (((code 241)
           (verifiers
            (((name 04) (condition (Equal_value (symbol Square) (value 4))))
             ((name 09) (condition (Has_digit_count (digit 3) (count 0))))
             ((name 11) (condition (Less_than (a Triangle) (b Square))))
             ((name 14) (condition (Is_smallest (symbol Circle)))))))
          ((code 545)
           (verifiers
            (((name 04) (condition (Equal_value (symbol Square) (value 4))))
             ((name 09) (condition (Has_digit_count (digit 3) (count 0))))
             ((name 11) (condition (Greater_than (a Triangle) (b Square))))
             ((name 14) (condition (Is_smallest (symbol Square))))))))))))) |}];
  print_max_number_of_remaining_codes ~resolution_path;
  [%expect {| ((max_number_of_remaining_codes 3)) |}];
  ()
;;

let%expect_test "incomplete resolution_path" =
  let resolution_path =
    { Resolution_path.rounds =
        [ { code = { triangle = One; square = Four; circle = Three }
          ; verifiers = [ verifier_04.name ]
          }
        ; { code = { triangle = Two; square = One; circle = Five }
          ; verifiers = [ verifier_09.name; verifier_11.name; verifier_14.name ]
          }
        ]
    }
  in
  print_is_complete ~resolution_path;
  [%expect
    {|
    ((is_complete
      (No_with_counter_example
       ((results
         (((code 143) (verifier 04) (result false))
          ((code 215) (verifier 09) (result false))
          ((code 215) (verifier 11) (result false))
          ((code 215) (verifier 14) (result false))))
        (hypotheses
         (((code 231)
           (verifiers
            (((name 04) (condition (Less_than_value (symbol Square) (value 4))))
             ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
             ((name 11) (condition (Less_than (a Triangle) (b Square))))
             ((name 14) (condition (Is_smallest (symbol Circle)))))))
          ((code 553)
           (verifiers
            (((name 04)
              (condition (Greater_than_value (symbol Square) (value 4))))
             ((name 09) (condition (Has_digit_count (digit 3) (count 1))))
             ((name 11) (condition (Equal (a Triangle) (b Square))))
             ((name 14) (condition (Is_smallest (symbol Circle))))))))))))) |}];
  print_max_number_of_remaining_codes ~resolution_path;
  [%expect {| ((max_number_of_remaining_codes 2)) |}];
  ()
;;

let%expect_test "complete resolution_path" =
  let resolution_path =
    { Resolution_path.rounds =
        [ { code = { triangle = One; square = Four; circle = Three }
          ; verifiers = [ verifier_04.name ]
          }
        ; { code = { triangle = Two; square = One; circle = Five }
          ; verifiers = [ verifier_09.name; verifier_11.name; verifier_14.name ]
          }
        ; { code = { triangle = Two; square = Three; circle = One }
          ; verifiers = [ verifier_04.name ]
          }
        ]
    }
  in
  print_is_complete ~resolution_path;
  [%expect {| ((is_complete Yes)) |}];
  print_max_number_of_remaining_codes ~resolution_path;
  [%expect {| ((max_number_of_remaining_codes 1)) |}];
  ()
;;

let%expect_test "shrink" =
  let resolution_path =
    { Resolution_path.rounds =
        [ { code = { triangle = One; square = Four; circle = Three }
          ; verifiers = [ verifier_04.name; verifier_14.name ]
          }
        ; { code = { triangle = Two; square = One; circle = Five }
          ; verifiers = [ verifier_09.name; verifier_11.name; verifier_14.name ]
          }
        ; { code = { triangle = Two; square = Three; circle = One }
          ; verifiers = [ verifier_04.name; verifier_11.name ]
          }
        ]
    }
  in
  print_is_complete ~resolution_path;
  [%expect {| ((is_complete Yes)) |}];
  let shrunk = Solver.shrink_resolution_path ~decoder ~resolution_path in
  print_s [%sexp (shrunk : Resolution_path.t list)];
  [%expect
    {|
    (((rounds
       (((code 143) (verifiers (04))) ((code 215) (verifiers (09 11)))
        ((code 231) (verifiers (04))))))
     ((rounds
       (((code 143) (verifiers (04))) ((code 215) (verifiers (09 11)))
        ((code 231) (verifiers (11))))))
     ((rounds
       (((code 143) (verifiers (04))) ((code 215) (verifiers (11 14)))
        ((code 231) (verifiers (04 11))))))) |}];
  ()
;;
