open! Core
open! Turing_game

let decoder = Decoders.v_01

let print_is_complete ~resolution_path =
  print_s
    [%sexp
      { is_complete =
          (Complete_solver.is_complete_resolution_path_with_trace
             ~decoder
             ~resolution_path
            : Complete_solver.Is_complete_result.t)
      }]
;;

let print_max_number_of_remaining_codes ~resolution_path =
  let max_number_of_remaining_codes =
    Complete_solver.max_number_of_remaining_codes ~decoder ~resolution_path
  in
  print_s [%sexp { max_number_of_remaining_codes : int }]
;;

let%expect_test "incomplete resolution_path" =
  let resolution_path =
    let open Verifiers in
    { Resolution_path.rounds =
        [ { code = { triangle = One; square = Four; circle = Three }
          ; verifiers = [ v_09.name ]
          }
        ; { code = { triangle = Two; square = One; circle = Five }
          ; verifiers = [ v_04.name ]
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
    let open Verifiers in
    { Resolution_path.rounds =
        [ { code = { triangle = One; square = Four; circle = Three }
          ; verifiers = [ v_04.name ]
          }
        ; { code = { triangle = Two; square = One; circle = Five }
          ; verifiers = [ v_09.name; v_11.name; v_14.name ]
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
    let open Verifiers in
    { Resolution_path.rounds =
        [ { code = { triangle = One; square = Four; circle = Three }
          ; verifiers = [ v_04.name ]
          }
        ; { code = { triangle = Two; square = One; circle = Five }
          ; verifiers = [ v_09.name; v_11.name; v_14.name ]
          }
        ; { code = { triangle = Two; square = Three; circle = One }
          ; verifiers = [ v_04.name ]
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
    let open Verifiers in
    { Resolution_path.rounds =
        [ { code = { triangle = One; square = Four; circle = Three }
          ; verifiers = [ v_04.name; v_14.name ]
          }
        ; { code = { triangle = Two; square = One; circle = Five }
          ; verifiers = [ v_09.name; v_11.name; v_14.name ]
          }
        ; { code = { triangle = Two; square = Three; circle = One }
          ; verifiers = [ v_04.name; v_11.name ]
          }
        ]
    }
  in
  print_is_complete ~resolution_path;
  [%expect {| ((is_complete Yes)) |}];
  let shrunk = Complete_solver.shrink_resolution_path ~decoder ~resolution_path in
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

let%expect_test "quick-solve" =
  let test decoder =
    let resolution_path =
      Complete_solver.quick_solve ~decoder |> Option.value_exn ~here:[%here]
    in
    Expect_test_helpers_base.require
      [%here]
      (Complete_solver.is_complete_resolution_path ~decoder ~resolution_path);
    [%expect {||}];
    let max_number_of_remaining_codes =
      Complete_solver.max_number_of_remaining_codes ~decoder ~resolution_path
    in
    print_s [%sexp { max_number_of_remaining_codes : int }];
    [%expect {| ((max_number_of_remaining_codes 1)) |}];
    Expect_test_helpers_base.require_ok
      [%here]
      (Complete_solver.simulate_resolution_path_for_all_hypotheses
         ~decoder
         ~resolution_path);
    [%expect {||}];
    let cost = Resolution_path.cost resolution_path in
    print_s [%sexp { resolution_path : Resolution_path.t; cost : Resolution_path.Cost.t }];
    ()
  in
  let decoder1 = Decoders.v_01 in
  test decoder1;
  [%expect
    {|
    ((resolution_path
      ((rounds
        (((code 111) (verifiers (04 09 11))) ((code 141) (verifiers (04 09 11)))))))
     (cost ((number_of_rounds 2) (number_of_verifiers 6)))) |}];
  let decoder20 = Decoders.v_20 in
  test decoder20;
  [%expect
    {|
    ((resolution_path
      ((rounds
        (((code 514) (verifiers (30 33 40))) ((code 441) (verifiers (11 22 40)))
         ((code 141) (verifiers (30 33 34))) ((code 113) (verifiers (11 34 40)))
         ((code 131) (verifiers (11 22 40)))))))
     (cost ((number_of_rounds 5) (number_of_verifiers 15)))) |}];
  ()
;;
