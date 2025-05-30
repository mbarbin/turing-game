module Verifier_status = struct
  type t =
    | Undetermined of { remaining_criteria : Criteria.t Nonempty_list.t }
    | Determined of Criteria.t
  [@@deriving equal, sexp_of]
end

module Slot = struct
  type t =
    { index : int
    ; verifier : Verifier.t
    ; verifier_status : Verifier_status.t
    }
  [@@deriving equal, sexp_of]
end

module Hypothesis = struct
  module One_verifier = struct
    type t =
      { verifier_index : int
      ; criteria : Criteria.t
      }
    [@@deriving equal, sexp_of]

    let remaining_codes t ~remaining_codes =
      Codes.filter remaining_codes ~f:(fun code ->
        Predicate.evaluate t.criteria.predicate ~code)
    ;;
  end

  type t =
    { verifiers : One_verifier.t Immutable_array.t
    ; number_of_remaining_codes : int
    ; remaining_codes : Codes.t (* Must be non empty. *)
    }

  let sexp_of_t { verifiers; number_of_remaining_codes; remaining_codes } =
    match Codes.is_singleton remaining_codes with
    | Some code -> [%sexp { code : Code.t; verifiers : One_verifier.t Immutable_array.t }]
    | None ->
      [%sexp
        { number_of_remaining_codes : int; verifiers : One_verifier.t Immutable_array.t }]
  ;;

  let criteria_exn t ~verifier_index =
    t.verifiers
    |> Immutable_array.find_map ~f:(fun (verifier : One_verifier.t) ->
      Option.some_if (verifier_index = verifier.verifier_index) verifier.criteria)
    |> Option.value_exn ~here:[%here]
  ;;

  let remaining_code_exn t =
    match Codes.is_singleton t.remaining_codes with
    | Some code -> code
    | None ->
      raise_s
        [%sexp "Hypothesis is expected to have a unique remaining code", [%here], (t : t)]
  ;;

  let remaining_codes t = t.remaining_codes

  let evaluate_exn t ~code ~verifier_index =
    let criteria = criteria_exn t ~verifier_index in
    Predicate.evaluate criteria.predicate ~code
  ;;
end

type t =
  { slots : Slot.t Immutable_array.t
  ; mutable strict_hypotheses : Hypothesis.t list option
  }
[@@deriving sexp_of]

let create_internal ~slots = { slots; strict_hypotheses = None }

let create ~verifiers =
  let slots =
    verifiers
    |> Nonempty_list.to_array
    |> Immutable_array.of_array_mapi ~f:(fun index verifier ->
      { Slot.index
      ; verifier
      ; verifier_status =
          Undetermined
            { remaining_criteria =
                Nonempty_list.mapi verifier.predicates ~f:(fun index predicate ->
                  { Criteria.index; predicate })
            }
      })
  in
  create_internal ~slots
;;

let verifiers t =
  t.slots
  |> Immutable_array.to_list
  |> List.map ~f:(fun (slot : Slot.t) -> slot.verifier)
  |> Nonempty_list.of_list_exn
;;

let find_slot_with_verifier_index_exn t ~verifier_index =
  Immutable_array.find t.slots ~f:(fun slot -> verifier_index = slot.verifier.index)
  |> Option.value_exn ~here:[%here]
;;

let verifier_exn t ~verifier_index =
  let slot = find_slot_with_verifier_index_exn t ~verifier_index in
  { Verifier_info.verifier = slot.verifier
  ; verifier_letter = Verifier_letter.of_index slot.index
  }
;;

let verifier_status_exn t ~verifier_index =
  let slot = find_slot_with_verifier_index_exn t ~verifier_index in
  slot.verifier_status
;;

module Cycle_counter = struct
  type 'a t =
    { values : 'a array
    ; mutable current_value : int
    }
  [@@deriving equal, sexp_of]

  module Incr_result = struct
    type t =
      | Reset
      | Continue
  end

  let incr t =
    let len = Array.length t.values in
    if t.current_value = len - 1
    then (
      t.current_value <- 0;
      Incr_result.Reset)
    else (
      t.current_value <- t.current_value + 1;
      Incr_result.Continue)
  ;;
end

let compute_hypotheses (t : t) ~strict =
  let verifiers : Hypothesis.One_verifier.t Queue.t array =
    Array.init (Immutable_array.length t.slots) ~f:(fun _ -> Queue.create ())
  in
  Immutable_array.iteri t.slots ~f:(fun i slot ->
    let verifier_index = slot.verifier.index in
    match slot.verifier_status with
    | Undetermined { remaining_criteria } ->
      Nonempty_list.iter remaining_criteria ~f:(fun criteria ->
        Queue.enqueue verifiers.(i) { verifier_index; criteria })
    | Determined criteria -> Queue.enqueue verifiers.(i) { verifier_index; criteria });
  let verifiers =
    Array.map verifiers ~f:(fun queue ->
      { Cycle_counter.values = Queue.to_array queue; current_value = 0 })
  in
  let incr () =
    let rec aux i =
      match Cycle_counter.incr verifiers.(i) with
      | Continue -> true
      | Reset -> if i = 0 then false else aux (i - 1)
    in
    aux (Array.length verifiers - 1)
  in
  let hypotheses = Queue.create () in
  let rec loop () =
    let verifiers =
      verifiers
      |> Immutable_array.of_array_mapi
           ~f:(fun _ { Cycle_counter.values; current_value } -> values.(current_value))
    in
    let remaining_codes =
      Immutable_array.fold
        verifiers
        ~init:Codes.all
        ~f:(fun remaining_codes one_verifier ->
          Hypothesis.One_verifier.remaining_codes one_verifier ~remaining_codes)
    in
    let number_of_remaining_codes = Codes.length remaining_codes in
    if if strict then number_of_remaining_codes = 1 else number_of_remaining_codes > 0
    then
      Queue.enqueue
        hypotheses
        { Hypothesis.verifiers; number_of_remaining_codes; remaining_codes };
    if incr () then loop ()
  in
  loop ();
  Queue.to_list hypotheses
;;

let hypotheses ?(strict = true) t =
  if strict
  then (
    match t.strict_hypotheses with
    | Some hypotheses -> hypotheses
    | None ->
      let strict_hypotheses = compute_hypotheses t ~strict:true in
      t.strict_hypotheses <- Some strict_hypotheses;
      strict_hypotheses)
  else compute_hypotheses t ~strict:false
;;

let remaining_codes t =
  hypotheses t ~strict:true |> List.map ~f:Hypothesis.remaining_codes |> Codes.concat
;;

let number_of_remaining_codes t = Codes.length (remaining_codes t)

module Test_result = struct
  type nonrec t =
    | Ok of t
    | Inconsistency of Sexp.t
end

let add_test_result t ~code ~verifier_index ~result =
  let slot =
    match
      Immutable_array.find t.slots ~f:(fun slot -> verifier_index = slot.verifier.index)
    with
    | Some slot -> slot
    | None ->
      Err.raise
        [ Pp.text "Verifier not found in t."; Err.sexp [%sexp { verifier_index : int }] ]
  in
  let index = slot.index in
  match slot.verifier_status with
  | Determined { index; predicate } ->
    (* Nothing to learn. *)
    let expected_result = Predicate.evaluate predicate ~code in
    if Bool.equal expected_result result
    then Test_result.Ok t
    else
      Test_result.Inconsistency
        [%sexp
          { index : int
          ; verifier_status =
              Determined
                { predicate : Predicate.t; expected_result : bool; result : bool }
          }]
  | Undetermined { remaining_criteria } ->
    let verifier_status =
      let remaining_conditions =
        Nonempty_list.filter remaining_criteria ~f:(fun { index = _; predicate } ->
          Bool.equal result (Predicate.evaluate predicate ~code))
      in
      match remaining_conditions with
      | [ predicate ] -> Ok (Verifier_status.Determined predicate)
      | hd :: (_ :: _ as tl) ->
        Ok (Verifier_status.Undetermined { remaining_criteria = hd :: tl })
      | [] ->
        Error [%sexp "Verifier has no remaining possible predicate", { index : int }]
    in
    (match verifier_status with
     | Error error -> Test_result.Inconsistency error
     | Ok verifier_status ->
       let slots =
         Immutable_array.mapi t.slots ~f:(fun i slot ->
           if i = index then { slot with Slot.verifier_status } else slot)
       in
       Test_result.Ok (create_internal ~slots))
;;

module Criteria_and_probability = struct
  type t =
    { criteria : Criteria.t
    ; probability : float
    }
  [@@deriving equal, sexp_of]
end

let criteria_distribution_exn t ~verifier_index =
  let slot = find_slot_with_verifier_index_exn t ~verifier_index in
  let hypotheses = hypotheses t ~strict:true in
  let number_of_hypotheses = Float.of_int (List.length hypotheses) in
  match slot.verifier_status with
  | Determined criteria ->
    Nonempty_list.singleton { Criteria_and_probability.criteria; probability = 1. }
  | Undetermined { remaining_criteria } ->
    Nonempty_list.map remaining_criteria ~f:(fun criteria ->
      let number_of_hypotheses_with_this_criteria =
        List.count hypotheses ~f:(fun hypothesis ->
          criteria.index
          = (Immutable_array.get hypothesis.verifiers slot.index).criteria.index)
      in
      { Criteria_and_probability.criteria
      ; probability =
          Float.of_int number_of_hypotheses_with_this_criteria /. number_of_hypotheses
      })
;;
