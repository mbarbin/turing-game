open! Core
open! Import

module Expected_information_gained = struct
  (* Evaluate a test in term of expected information bits gained. *)
  type t =
    { bits_gained : float
    ; probability : float
    }
  [@@deriving sexp_of]

  let unreachable = { bits_gained = 0.; probability = 0. }

  let compute ~starting_number ~remaining_number =
    if starting_number = 0 || remaining_number = 0
    then unreachable
    else (
      let starting_number = Float.of_int starting_number in
      let starting_bits = Float.log2 starting_number in
      let remaining_bits = Float.log2 (Float.of_int remaining_number) in
      let probability = Float.of_int remaining_number /. starting_number in
      let bits_gained = starting_bits -. remaining_bits in
      { bits_gained; probability })
  ;;
end

module Evaluation = struct
  type t = { expected_information_gained : float } [@@deriving compare, sexp_of]

  let zero = { expected_information_gained = 0. }
  let is_zero t = Float.(t.expected_information_gained <= 0.)

  let compute (ts : Expected_information_gained.t Nonempty_list.t) =
    let expected_information_gained =
      Nonempty_list.fold ts ~init:0. ~f:(fun acc t ->
        acc +. (t.probability *. t.bits_gained))
    in
    { expected_information_gained }
  ;;
end

let evaluate_test ~decoder ~code ~verifier =
  let starting_number_of_remaining_codes = Decoder.number_of_remaining_codes decoder in
  if starting_number_of_remaining_codes <= 0
  then
    ( Evaluation.zero
    , Info.create_s [%sexp "Unreachable", { starting_number_of_remaining_codes : int }] )
  else (
    let compute_expected_information_gained ~result =
      match Decoder.add_test_result decoder ~code ~verifier ~result with
      | Error _ -> Expected_information_gained.unreachable
      | Ok decoder ->
        Expected_information_gained.compute
          ~starting_number:starting_number_of_remaining_codes
          ~remaining_number:(Decoder.number_of_remaining_codes decoder)
    in
    let score_if_true = compute_expected_information_gained ~result:true in
    let score_if_false = compute_expected_information_gained ~result:false in
    ( Evaluation.compute [ score_if_true; score_if_false ]
    , Info.create_s
        [%sexp
          { code : Code.t
          ; verifier = (verifier.name : Verifier.Name.t)
          ; score_if_true : Expected_information_gained.t
          ; score_if_false : Expected_information_gained.t
          }] ))
;;

let evaluate_code ~decoder ~code =
  let verifiers = Decoder.verifiers decoder in
  let initial_number_of_hypotheses = List.length (Decoder.hypotheses decoder) in
  let evaluate_keys ~keys =
    match
      Decoder.compute_test_results decoder ~keys
      |> Map.of_alist_multi (module Decoder.Test_results)
      |> Map.to_alist
      |> List.map ~f:(fun (_, hypotheses) ->
        Expected_information_gained.compute
          ~starting_number:initial_number_of_hypotheses
          ~remaining_number:(List.length hypotheses))
    with
    | [] -> Evaluation.zero
    | hd :: tl -> Evaluation.compute (hd :: tl)
  in
  let rec aux ~evaluation ~keys =
    if Array.length keys = 3
    then evaluation
    else (
      let evaluation, keys =
        Nonempty_list.map verifiers ~f:(fun verifier ->
          let keys =
            Array.append
              keys
              [| { Decoder.Test_results.Key.code; verifier = verifier.name } |]
          in
          evaluate_keys ~keys, keys)
        |> Nonempty_list.to_list
        |> List.max_elt ~compare:(fun (e1, _) (e2, _) -> Evaluation.compare e1 e2)
        |> Option.value_exn ~here:[%here]
      in
      aux ~evaluation ~keys)
  in
  aux ~keys:[||] ~evaluation:Evaluation.zero
;;

module Request_test = struct
  type t =
    { new_round : bool
    ; code : Code.t
    ; verifier : Verifier.Name.t
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
    let evaluation, info = evaluate_test ~decoder ~code ~verifier in
    if Evaluation.is_zero evaluation
    then None
    else Some (evaluation, (verifier.name, info)))
  |> pick_best_positive_evaluation
;;

let add_to_current_round ~decoder ~current_round =
  if current_round_is_finished ~current_round
  then None
  else pick_best_verifier ~decoder ~code:current_round.code
;;

let next_step ~decoder ~(current_round : Resolution_path.Round.t option) =
  let evaluation = Decoder.number_of_remaining_codes decoder in
  if evaluation = 1
  then
    Step.Propose_solution
      { code = Decoder.remaining_codes decoder |> Codes.to_list |> List.hd_exn }
  else (
    match
      match current_round with
      | None -> None
      | Some current_round ->
        (match add_to_current_round ~decoder ~current_round with
         | None -> None
         | Some (verifier, info) ->
           Some
             (Step.Request_test
                { new_round = false; code = current_round.code; verifier; info }))
    with
    | Some next_step -> next_step
    | None ->
      let code =
        List.map (Codes.all |> Codes.to_list) ~f:(fun code ->
          evaluate_code ~decoder ~code, code)
        |> List.max_elt ~compare:(fun (e1, _) (e2, _) -> Evaluation.compare e1 e2)
        |> Option.value_exn ~here:[%here]
        |> snd
      in
      (match pick_best_verifier ~decoder ~code with
       | Some (verifier, info) ->
         Step.Request_test { new_round = true; code; verifier; info }
       | None -> Error (Error.create_s [%sexp "Cannot make progress"])))
;;

let remaining_bits ~decoder =
  let number_of_remaining_codes = Decoder.number_of_remaining_codes decoder in
  if number_of_remaining_codes = 0
  then 0.
  else Float.log2 (Float.of_int number_of_remaining_codes)
;;

let simulate_resolution_for_hypothesis ~decoder ~hypothesis =
  let rec aux acc ~decoder ~rounds ~current_round =
    let next_step = next_step ~decoder ~current_round in
    let acc = next_step :: acc in
    match next_step with
    | Error _ -> List.rev acc
    | Propose_solution { code } ->
      let verification =
        let expected_code = Decoder.Hypothesis.remaining_code_exn hypothesis in
        if Code.equal expected_code code
        then Info.create_s [%sexp Ok "Code match hypothesis expected code"]
        else
          Info.create_s
            [%sexp Error "Code mismatch", { expected_code : Code.t; code : Code.t }]
      in
      let resolution_path =
        let rounds =
          match current_round with
          | None -> rounds
          | Some round -> round :: rounds
        in
        { Resolution_path.rounds = List.rev rounds |> Nonempty_list.of_list_exn }
      in
      let cost = Resolution_path.cost resolution_path in
      let additional_info =
        [ verification
        ; Info.create_s
            [%sexp { resolution_path : Resolution_path.t; cost : Resolution_path.Cost.t }]
        ]
        |> List.map ~f:(fun info -> Step.Info info)
      in
      List.rev (List.rev_append additional_info acc)
    | Info _ -> assert false
    | Request_test { new_round; code; verifier; info = _ } ->
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
        then { Resolution_path.Round.code; verifiers = [ verifier ] } |> Option.return
        else (
          let { Resolution_path.Round.code; verifiers } =
            current_round |> Option.value_exn ~here:[%here]
          in
          { Resolution_path.Round.code
          ; verifiers = Nonempty_list.append verifiers [ verifier ]
          }
          |> Option.return)
      in
      let condition = Decoder.Hypothesis.verifier_exn hypothesis ~name:verifier in
      let result = Condition.evaluate condition ~code in
      let remaining_bits_before = remaining_bits ~decoder in
      (match
         let verifier = Decoder.verifier_exn decoder ~name:verifier in
         Decoder.add_test_result decoder ~code ~verifier ~result
       with
       | Error error ->
         let acc = Step.Error error :: acc in
         List.rev acc
       | Ok decoder ->
         let info =
           let number_of_remaining_codes = Decoder.number_of_remaining_codes decoder in
           let remaining_bits = remaining_bits ~decoder in
           let bits_gained = remaining_bits_before -. remaining_bits in
           Info.create_s
             [%sexp
               Test_result
                 { code : Code.t
                 ; verifier : Verifier.Name.t
                 ; condition : Condition.t
                 ; result : bool
                 ; remaining_bits_before : float
                 ; bits_gained : float
                 ; remaining_bits : float
                 ; number_of_remaining_codes : int
                 }]
         in
         aux (Step.Info info :: acc) ~decoder ~rounds ~current_round)
  in
  let introduction =
    let remaining_bits = remaining_bits ~decoder in
    let number_of_remaining_codes = Decoder.number_of_remaining_codes decoder in
    [ Info.create_s [%sexp { remaining_bits : float; number_of_remaining_codes : int }] ]
  in
  let acc = List.rev_map introduction ~f:(fun info -> Step.Info info) in
  aux acc ~decoder ~rounds:[] ~current_round:None
;;

let input_line () = Stdio.In_channel.(input_line_exn stdin)

let input_test_result ~code ~verifier =
  let rec input_bool ~prompt =
    print_string ("\n" ^ prompt);
    Stdio.Out_channel.(flush stdout);
    let bool = input_line () in
    print_string "\n";
    Stdio.Out_channel.(flush stdout);
    match Bool.of_string bool with
    | exception e ->
      print_s [%sexp (e : Exn.t)];
      input_bool ~prompt
    | b -> b
  in
  input_bool
    ~prompt:
      (sprintf
         "Enter result for test. code=%S - verifier=%S: "
         (Code.to_string code)
         ((verifier : Verifier.Name.t) :> string))
;;

let wait_for_newline ~prompt =
  print_string ("\n" ^ prompt ^ " Type ENTER to continue...");
  Stdio.Out_channel.(flush stdout);
  let (_ : string) = input_line () in
  print_string "\n";
  Stdio.Out_channel.(flush stdout);
  ()
;;

let interactive_solve ~decoder ~(return : unit Or_error.t With_return.return) =
  let rec aux ~decoder ~rounds ~current_round =
    let next_step = next_step ~decoder ~current_round in
    match next_step with
    | Error e -> return.return (Error e)
    | Propose_solution { code = _ } ->
      let resolution_path =
        let rounds =
          match current_round with
          | None -> rounds
          | Some round -> round :: rounds
        in
        { Resolution_path.rounds = List.rev rounds |> Nonempty_list.of_list_exn }
      in
      let cost = Resolution_path.cost resolution_path in
      let info =
        [ Info.create_s
            [%sexp { resolution_path : Resolution_path.t; cost : Resolution_path.Cost.t }]
        ]
      in
      wait_for_newline ~prompt:"Ready to propose a solution.";
      List.iter info ~f:(fun info -> print_s [%sexp (info : Info.t)]);
      print_s [%sexp (next_step : Step.t)];
      Stdio.Out_channel.(flush stdout)
    | Info _ -> assert false
    | Request_test { new_round; code; verifier; info = _ } ->
      let rounds =
        if new_round
        then (
          match current_round with
          | None -> rounds
          | Some round -> round :: rounds)
        else rounds
      in
      let () =
        if new_round && Option.is_some current_round
        then
          wait_for_newline
            ~prompt:"No more test to run with this code.\nReady for next round."
        else wait_for_newline ~prompt:"Ready to request a new test."
      in
      print_s [%sexp (next_step : Step.t)];
      let result = input_test_result ~code ~verifier in
      let remaining_bits_before = remaining_bits ~decoder in
      (match
         let verifier = Decoder.verifier_exn decoder ~name:verifier in
         Decoder.add_test_result decoder ~code ~verifier ~result
       with
       | Error _ as error -> return.return error
       | Ok decoder ->
         let info =
           let number_of_remaining_codes = Decoder.number_of_remaining_codes decoder in
           let remaining_bits = remaining_bits ~decoder in
           let bits_gained = remaining_bits_before -. remaining_bits in
           Info.create_s
             [%sexp
               Test_result
                 { code : Code.t
                 ; verifier : Verifier.Name.t
                 ; result : bool
                 ; remaining_bits_before : float
                 ; bits_gained : float
                 ; remaining_bits : float
                 ; number_of_remaining_codes : int
                 }]
         in
         print_s [%sexp (info : Info.t)];
         Stdio.Out_channel.(flush stdout);
         let current_round =
           if new_round
           then { Resolution_path.Round.code; verifiers = [ verifier ] } |> Option.return
           else (
             let { Resolution_path.Round.code; verifiers } =
               current_round |> Option.value_exn ~here:[%here]
             in
             { Resolution_path.Round.code
             ; verifiers = Nonempty_list.append verifiers [ verifier ]
             }
             |> Option.return)
         in
         aux ~decoder ~rounds ~current_round)
  in
  let introduction =
    let remaining_bits = remaining_bits ~decoder in
    let number_of_remaining_codes = Decoder.number_of_remaining_codes decoder in
    [ Info.create_s [%sexp { remaining_bits : float; number_of_remaining_codes : int }] ]
  in
  List.iter introduction ~f:(fun info -> print_s [%sexp (info : Info.t)]);
  Stdio.Out_channel.(flush stdout);
  aux ~decoder ~rounds:[] ~current_round:None
;;

let simulate_all_hypotheses ~decoder =
  List.iter (Decoder.hypotheses decoder) ~f:(fun hypothesis ->
    print_endline "============= NEW HYPOTHESIS =============";
    print_s [%sexp (hypothesis : Decoder.Hypothesis.t)];
    let steps = simulate_resolution_for_hypothesis ~decoder ~hypothesis in
    print_s [%sexp (steps : Step.t list)])
;;

let make_command ~index ~decoder =
  Command.basic
    ~summary:(sprintf "solve problem %d interactively" index)
    (let%map_open.Command stress_test =
       flag "stress-test" no_arg ~doc:" run for all hypotheses"
     in
     fun () ->
       if stress_test
       then simulate_all_hypotheses ~decoder
       else (
         match
           with_return (fun return ->
             interactive_solve ~decoder ~return;
             Ok ())
         with
         | Ok () -> ()
         | Error e ->
           prerr_endline (Error.to_string_hum e);
           exit 1))
;;

let cmd =
  Command.group
    ~summary:"interactive solver"
    (List.map Decoders.all ~f:(fun (index, decoder) ->
       Int.to_string index, make_command ~index ~decoder))
;;
