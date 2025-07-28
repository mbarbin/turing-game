module Expected_information_gained = struct
  (* Evaluate a test in term of expected information bits gained. *)
  type t =
    { bits_gained : float
    ; probability : float
    }
  [@@deriving sexp_of]

  let unreachable = { bits_gained = 0.; probability = 0. }

  let compute ~starting_number ~remaining_number ~probability =
    if starting_number = 0 || remaining_number = 0
    then unreachable
    else (
      let starting_number = Float.of_int starting_number in
      let starting_bits = Float.log2 starting_number in
      let remaining_bits = Float.log2 (Float.of_int remaining_number) in
      let bits_gained = starting_bits -. remaining_bits in
      { bits_gained; probability })
  ;;
end

module Evaluation = struct
  type t = { expected_information_gained : float } [@@deriving compare, sexp_of]

  let zero = { expected_information_gained = 0. }
  let is_zero t = Float.(t.expected_information_gained <= 0.)

  let compute (ts : Expected_information_gained.t Nonempty_list.t) =
    let () =
      let sum_probabilities =
        Nonempty_list.sum (module Float) ts ~f:(fun t -> t.probability)
      in
      if Float.( >= ) (Float.abs (1. -. sum_probabilities)) 1e-7
      then
        Err.raise
          [ Pp.text "Sum of probabilities does not equal 1."
          ; Err.sexp
              [%sexp
                (ts : Expected_information_gained.t Nonempty_list.t)
              , { sum_probabilities : float }]
          ]
    in
    let expected_information_gained =
      Nonempty_list.fold ts ~init:0. ~f:(fun acc t ->
        acc +. (t.probability *. t.bits_gained))
    in
    { expected_information_gained }
  ;;
end

module Test_evaluation = struct
  type t =
    { evaluation : Evaluation.t
    ; score_if_true : Expected_information_gained.t
    ; score_if_false : Expected_information_gained.t
    ; info : Info.t
    }
  [@@deriving sexp_of]
end

let evaluate_test ~decoder ~code ~(verifier : Verifier.t) =
  let verifier_index = verifier.index in
  let starting_number_of_remaining_codes = Decoder.number_of_remaining_codes decoder in
  if starting_number_of_remaining_codes <= 0
  then
    { Test_evaluation.evaluation = Evaluation.zero
    ; score_if_true = Expected_information_gained.unreachable
    ; score_if_false = Expected_information_gained.unreachable
    ; info =
        Info.create_s [%sexp "Unreachable", { starting_number_of_remaining_codes : int }]
    }
  else (
    let criteria_distribution =
      Decoder.criteria_distribution_exn decoder ~verifier_index
      |> Nonempty_list.map ~f:(fun (c : Decoder.Criteria_and_probability.t) ->
        c, Predicate.evaluate c.criteria.predicate ~code)
    in
    let compute_expected_information_gained ~result =
      match Decoder.add_test_result decoder ~code ~verifier_index ~result with
      | Inconsistency _ -> Expected_information_gained.unreachable
      | Ok decoder ->
        let probability =
          Nonempty_list.sum
            (module Float)
            criteria_distribution
            ~f:(fun ({ criteria = _; probability }, criteria_result) ->
              if Bool.equal result criteria_result then probability else 0.)
        in
        Expected_information_gained.compute
          ~starting_number:starting_number_of_remaining_codes
          ~remaining_number:(Decoder.number_of_remaining_codes decoder)
          ~probability
    in
    let score_if_true = compute_expected_information_gained ~result:true in
    let score_if_false = compute_expected_information_gained ~result:false in
    let evaluation = Evaluation.compute [ score_if_true; score_if_false ] in
    { Test_evaluation.evaluation
    ; score_if_true
    ; score_if_false
    ; info =
        Info.create_s
          [%sexp
            { code : Code.t
            ; verifier_index : int
            ; score_if_true : Expected_information_gained.t
            ; score_if_false : Expected_information_gained.t
            }]
    })
;;

module Test_key = struct
  type t =
    { code : Code.t
    ; verifier_index : int
    }
  [@@deriving compare, equal, hash, sexp_of]
end

module Test_results = struct
  module T = struct
    type t = bool array [@@deriving compare, equal, sexp_of]
  end

  include T
  include Comparator.Make (T)
end

(* For each hypothesis, run the tests present in the test keys and return their
   results. When then aggregate the remaining codes per test result, so as to
   compute the expected information gained for each of the test keys. *)

let compute_test_results ~hypotheses ~test_keys =
  List.map hypotheses ~f:(fun hypothesis ->
    let test_results =
      Array.map test_keys ~f:(fun { Test_key.code; verifier_index } ->
        Decoder.Hypothesis.evaluate_exn hypothesis ~code ~verifier_index)
    in
    test_results, hypothesis)
;;

let evaluate_code ~decoder ~code =
  let hypotheses = Decoder.hypotheses decoder in
  let initial_number_of_hypotheses = List.length hypotheses |> Float.of_int in
  let verifiers = Decoder.verifiers decoder in
  let initial_number_of_codes = Decoder.number_of_remaining_codes decoder in
  let evaluate_test_keys ~test_keys =
    match
      compute_test_results ~hypotheses ~test_keys
      |> Map.of_alist_fold
           (module Test_results)
           ~init:(0, Codes.empty)
           ~f:(fun (h, codes) hypothesis ->
             h + 1, Codes.append codes (Decoder.Hypothesis.remaining_codes hypothesis))
      |> Map.to_alist
      |> List.map ~f:(fun (_, (remaining_number_of_hypotheses, remaining_codes)) ->
        let remaining_number = Codes.length remaining_codes in
        Expected_information_gained.compute
          ~starting_number:initial_number_of_codes
          ~remaining_number
          ~probability:
            Float.(of_int remaining_number_of_hypotheses /. initial_number_of_hypotheses))
    with
    | [] -> Evaluation.zero
    | hd :: tl -> Evaluation.compute (hd :: tl)
  in
  let rec aux ~evaluation ~test_keys =
    if Array.length test_keys = 3
    then evaluation
    else (
      let evaluation, test_keys =
        Nonempty_list.map verifiers ~f:(fun verifier ->
          let test_keys =
            Array.append
              test_keys
              [| { Test_key.code; verifier_index = verifier.index } |]
          in
          evaluate_test_keys ~test_keys, test_keys)
        |> Nonempty_list.max_elt' ~compare:(fun (e1, _) (e2, _) ->
          Evaluation.compare e1 e2)
      in
      aux ~evaluation ~test_keys)
  in
  aux ~test_keys:[||] ~evaluation:Evaluation.zero
;;

module Request_test = struct
  type t =
    { new_round : bool
    ; code : Code.t
    ; verifier_index : int
    ; info : Info.t
    }
  [@@deriving sexp_of]
end

module Step = struct
  type t =
    | Request_test of Request_test.t
    | Propose_solution of { code : Code.t }
    | Error of Error.t
    | Info of Info.t
  [@@deriving sexp_of]
end

(* When do we choose to run an additional verifier rather than starting a new
   round, when both are possible?

   Not using all possible tests of the current round seems like a waste, so the
   question can be rephrased as such: In which (presumably rare) cases do we
   decide that it is not worth using all possible tests for the current round?

   1. Easy case: when none of the remaining possible tests would add any
   information.

   2. Imagine we know that on the next round, we'll be able to determine the
   same amount of information regardless of the added information that we
   could get at the current round, and that we're going to have to do it
   anyways, saving the current additional test will yield a better score
   overall. This is left for future work. *)

let current_round_is_finished ~(current_round : Resolution_path.Round.t) =
  Nonempty_list.length current_round.verifiers >= 3
;;

let pick_best_positive_evaluation alist =
  alist
  |> List.max_elt ~compare:(fun (e1, _) (e2, _) -> Evaluation.compare e1 e2)
  |> Option.bind ~f:(fun (e, r) -> Option.some_if (not (Evaluation.is_zero e)) r)
;;

let pick_best_verifier ~decoder ~code =
  Nonempty_list.filter_map (Decoder.verifiers decoder) ~f:(fun verifier ->
    let { Test_evaluation.evaluation; info; _ } =
      evaluate_test ~decoder ~code ~verifier
    in
    if Evaluation.is_zero evaluation
    then None
    else Some (evaluation, (verifier.index, info)))
  |> pick_best_positive_evaluation
;;

let add_to_current_round ~decoder ~current_round =
  if current_round_is_finished ~current_round
  then None
  else pick_best_verifier ~decoder ~code:current_round.code
;;

let next_step ~decoder ~(current_round : Resolution_path.Round.t option) =
  match Codes.is_singleton (Decoder.remaining_codes decoder) with
  | Some code -> Step.Propose_solution { code }
  | None ->
    (match
       match current_round with
       | None -> None
       | Some current_round ->
         (match add_to_current_round ~decoder ~current_round with
          | None -> None
          | Some (verifier_index, info) ->
            Some
              (Step.Request_test
                 { new_round = false; code = current_round.code; verifier_index; info }))
     with
     | Some next_step -> next_step
     | None ->
       let code =
         Codes.map Codes.all ~f:(fun code -> evaluate_code ~decoder ~code, code)
         |> List.max_elt ~compare:(fun (e1, _) (e2, _) -> Evaluation.compare e1 e2)
         |> Option.value_exn ~here:[%here]
         |> snd
       in
       (match pick_best_verifier ~decoder ~code with
        | Some (verifier_index, info) ->
          Step.Request_test { new_round = true; code; verifier_index; info }
        | None -> Error (Error.create_s [%sexp "Cannot make progress"])))
;;

let remaining_bits ~decoder =
  let number_of_remaining_codes = Decoder.number_of_remaining_codes decoder in
  if number_of_remaining_codes = 0
  then 0.
  else Float.log2 (Float.of_int number_of_remaining_codes)
;;

let input_line () = In_channel.(input_line_exn stdin)

let input_test_result ~code ~verifier_index ~verifier_letter =
  let rec input_bool ~prompt =
    print_string ("\n" ^ prompt);
    Out_channel.(flush stdout);
    let bool = input_line () in
    print_string "\n";
    Out_channel.(flush stdout);
    match Bool.of_string bool with
    | exception e ->
      print_s [%sexp (e : Exn.t)];
      input_bool ~prompt
    | b -> b
  in
  input_bool
    ~prompt:
      (Printf.sprintf
         "Enter result for test. code=%s - verifier=%s(%02d): "
         (Code.to_string code)
         (Verifier_letter.to_string verifier_letter)
         (verifier_index : int))
;;

let wait_for_newline ~prompt =
  print_string ("\n" ^ prompt ^ " Type ENTER to continue...");
  Out_channel.(flush stdout);
  let (_ : string) = input_line () in
  print_string "\n";
  Out_channel.(flush stdout);
  ()
;;

module Running_mode = struct
  type t =
    | Interactive
    | Simulated_hypothesis of Decoder.Hypothesis.t

  let is_interactive = function
    | Interactive -> true
    | Simulated_hypothesis _ -> false
  ;;
end

let interactive_solve ~decoder ~(running_mode : Running_mode.t) =
  let rec aux ~decoder ~(rounds : Resolution_path.Round.t Reversed_list.t) ~current_round =
    (if Running_mode.is_interactive running_mode then Out_channel.(flush stdout));
    let next_step = next_step ~decoder ~current_round in
    match next_step with
    | Error e ->
      Err.raise [ Pp.text "Interactive solver failed."; Err.sexp (Error.sexp_of_t e) ]
    | Propose_solution { code } ->
      let resolution_path =
        let rounds =
          match current_round with
          | None -> rounds
          | Some round -> round :: rounds
        in
        { Resolution_path.rounds = Reversed_list.rev rounds |> Nonempty_list.of_list_exn }
      in
      let cost = Resolution_path.cost resolution_path in
      let info =
        [ Info.create_s
            [%sexp { resolution_path : Resolution_path.t; cost : Resolution_path.Cost.t }]
        ]
      in
      if Running_mode.is_interactive running_mode
      then wait_for_newline ~prompt:"Ready to propose a solution.";
      List.iter info ~f:(fun info -> print_s [%sexp Info, (info : Info.t)]);
      print_s [%sexp (next_step : Step.t)];
      code
    | Info _ -> assert false
    | Request_test { new_round; code; verifier_index; info = _ } ->
      if Running_mode.is_interactive running_mode
      then
        if new_round && Option.is_some current_round
        then
          wait_for_newline
            ~prompt:"No more test to run with this code.\nReady for next round."
        else wait_for_newline ~prompt:"Ready to request a new test.";
      print_s [%sexp (next_step : Step.t)];
      let { Verifier_info.verifier = _; verifier_letter } =
        Decoder.verifier_exn decoder ~verifier_index
      in
      let result =
        match running_mode with
        | Interactive -> input_test_result ~code ~verifier_index ~verifier_letter
        | Simulated_hypothesis hypothesis ->
          let criteria = Decoder.Hypothesis.criteria_exn hypothesis ~verifier_index in
          Predicate.evaluate criteria.predicate ~code
      in
      let remaining_bits_before = remaining_bits ~decoder in
      let decoder =
        match Decoder.add_test_result decoder ~code ~verifier_index ~result with
        | Ok t -> t
        | Inconsistency sexp ->
          Err.raise [ Pp.text "Internal error during solving."; Err.sexp sexp ]
      in
      let () =
        let number_of_remaining_codes = Decoder.number_of_remaining_codes decoder in
        let remaining_bits = remaining_bits ~decoder in
        let bits_gained = remaining_bits_before -. remaining_bits in
        let predicate =
          match running_mode with
          | Simulated_hypothesis hypothesis ->
            let criteria = Decoder.Hypothesis.criteria_exn hypothesis ~verifier_index in
            Info.create_s [%sexp (criteria : Criteria.t)]
          | Interactive ->
            (match Decoder.verifier_status_exn decoder ~verifier_index with
             | Undetermined _ -> Info.create_s [%sexp Undetermined]
             | Determined criteria -> Info.create_s [%sexp (criteria : Criteria.t)])
        in
        print_s
          [%sexp
            Test_result
              { code : Code.t
              ; verifier_letter : Verifier_letter.t
              ; verifier_index : int
              ; predicate : Info.t
              ; result : bool
              ; remaining_bits_before : float
              ; bits_gained : float
              ; remaining_bits : float
              ; number_of_remaining_codes : int
              }]
      in
      let rounds =
        if new_round
        then (
          match current_round with
          | None -> rounds
          | Some round -> round :: rounds)
        else rounds
      in
      let current_round =
        if new_round
        then { Resolution_path.Round.code; verifiers = [ verifier_index ] }
        else (
          let { Resolution_path.Round.code; verifiers } =
            current_round |> Option.value_exn ~here:[%here]
          in
          { Resolution_path.Round.code
          ; verifiers = Nonempty_list.append verifiers [ verifier_index ]
          })
      in
      aux ~decoder ~rounds ~current_round:(Some current_round)
  in
  let () =
    let remaining_bits = remaining_bits ~decoder in
    let number_of_remaining_codes = Decoder.number_of_remaining_codes decoder in
    List.iter
      ~f:(fun sexp -> print_s sexp)
      [ [%sexp Info { remaining_bits : float; number_of_remaining_codes : int }] ]
  in
  aux ~decoder ~rounds:[] ~current_round:None
;;

module Which_hypotheses = struct
  type t =
    | All
    | This of Decoder.Hypothesis.t
    | Only_the_first_n of { n : int }
end

let simulate_hypotheses ~decoder ~which_hypotheses =
  let hypotheses =
    let all = Decoder.hypotheses decoder in
    match (which_hypotheses : Which_hypotheses.t) with
    | All -> all
    | This h -> [ h ]
    | Only_the_first_n { n } -> List.take all n
  in
  List.iter hypotheses ~f:(fun hypothesis ->
    print_endline "============= NEW HYPOTHESIS =============";
    print_s [%sexp (hypothesis : Decoder.Hypothesis.t)];
    let code =
      interactive_solve ~decoder ~running_mode:(Simulated_hypothesis hypothesis)
    in
    let expected_code = Decoder.Hypothesis.remaining_code_exn hypothesis in
    if Code.equal expected_code code
    then print_s [%sexp Ok "Code match hypothesis expected code"]
    else raise_s [%sexp Error "Code mismatch", { expected_code : Code.t; code : Code.t }])
;;

let cmd =
  Command.make
    ~summary:"Solve a game interactively."
    (let%map_open.Command () = Log_cli.set_config ()
     and stress_test = Arg.flag [ "stress-test" ] ~doc:"Run for all hypotheses."
     and verifiers =
       Arg.named
         [ "verifiers" ]
         (Param.comma_separated Param.int)
         ~doc:"Specify verifiers."
       >>| Nonempty_list.of_list_exn
     in
     let config = Config.load_exn () in
     let decoder = Config.decoder_exn config verifiers in
     if stress_test
     then simulate_hypotheses ~decoder ~which_hypotheses:All
     else ignore (interactive_solve ~decoder ~running_mode:Interactive : Code.t))
;;
