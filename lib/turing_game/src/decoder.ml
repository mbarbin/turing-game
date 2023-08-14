open! Core

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
      { verifier_name : Verifier_name.t
      ; criteria : Criteria.t
      }
    [@@deriving equal, sexp_of]

    let remaining_codes t ~remaining_codes =
      Codes.filter remaining_codes ~f:(fun code ->
        Condition.evaluate t.criteria.condition ~code)
    ;;
  end

  type t =
    { verifiers : (One_verifier.t, immutable) Array.Permissioned.t
    ; number_of_remaining_codes : int
    ; remaining_codes : Codes.t (* Must be non empty. *)
    }

  let sexp_of_t { verifiers; number_of_remaining_codes; remaining_codes } =
    match Codes.is_singleton remaining_codes with
    | Some code ->
      [%sexp
        { code : Code.t; verifiers : (One_verifier.t, immutable) Array.Permissioned.t }]
    | None ->
      [%sexp
        { number_of_remaining_codes : int
        ; verifiers : (One_verifier.t, immutable) Array.Permissioned.t
        }]
  ;;

  let verifier_exn t ~verifier_name =
    t.verifiers
    |> Array.Permissioned.to_list
    |> List.find_map_exn ~f:(fun verifier ->
      Option.some_if
        (Verifier_name.equal verifier_name verifier.verifier_name)
        verifier.criteria)
  ;;

  let remaining_code_exn t =
    match Codes.is_singleton t.remaining_codes with
    | Some code -> code
    | None ->
      raise_s
        [%sexp "Hypothesis is expected to have a unique remaining code", [%here], (t : t)]
  ;;

  let remaining_codes t = t.remaining_codes

  let evaluate_exn t ~code ~verifier_name =
    let criteria = verifier_exn t ~verifier_name in
    Condition.evaluate criteria.condition ~code
  ;;
end

type t =
  { slots : (Slot.t, immutable) Array.Permissioned.t
  ; mutable strict_hypotheses : Hypothesis.t list option
  }
[@@deriving sexp_of]

let create_internal ~slots = { slots; strict_hypotheses = None }

let create ~verifiers =
  let slots =
    verifiers
    |> Nonempty_list.to_array
    |> Array.Permissioned.of_array_id
    |> Array.Permissioned.mapi ~f:(fun index verifier ->
      { Slot.index
      ; verifier
      ; verifier_status = Undetermined { remaining_criteria = verifier.criteria }
      })
  in
  create_internal ~slots
;;

let verifiers t =
  t.slots
  |> Array.Permissioned.to_list
  |> List.map ~f:(fun slot -> slot.verifier)
  |> Nonempty_list.of_list_exn
;;

let find_slot_with_verifier_name_exn t ~verifier_name =
  Array.Permissioned.find_exn t.slots ~f:(fun slot ->
    Verifier_name.equal verifier_name slot.verifier.verifier_name)
;;

let verifier_exn t ~verifier_name =
  let slot = find_slot_with_verifier_name_exn t ~verifier_name in
  { Verifier_info.verifier = slot.verifier
  ; verifier_letter = Verifier_letter.of_index slot.index
  }
;;

let verifier_status_exn t ~verifier_name =
  let slot = find_slot_with_verifier_name_exn t ~verifier_name in
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
    Array.init (Array.Permissioned.length t.slots) ~f:(fun _ -> Queue.create ())
  in
  Array.Permissioned.iteri t.slots ~f:(fun i slot ->
    let verifier_name = slot.verifier.verifier_name in
    match slot.verifier_status with
    | Undetermined { remaining_criteria } ->
      Nonempty_list.iter remaining_criteria ~f:(fun criteria ->
        Queue.enqueue verifiers.(i) { verifier_name; criteria })
    | Determined criteria -> Queue.enqueue verifiers.(i) { verifier_name; criteria });
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
      |> Array.Permissioned.of_array_id
      |> Array.Permissioned.map ~f:(fun { Cycle_counter.values; current_value } ->
        values.(current_value))
    in
    let remaining_codes =
      Array.Permissioned.fold
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

let add_test_result t ~code ~verifier ~result =
  let open Or_error.Let_syntax in
  let slot =
    match
      Array.Permissioned.find t.slots ~f:(fun slot -> phys_equal verifier slot.verifier)
    with
    | Some slot -> slot
    | None -> raise_s [%sexp "Verifier not found in t", { verifier : Verifier.t }]
  in
  let index = slot.index in
  match slot.verifier_status with
  | Determined { index; condition } ->
    (* Nothing to learn. *)
    let expected_result = Condition.evaluate condition ~code in
    if Bool.equal expected_result result
    then return t
    else
      Or_error.error_s
        [%sexp
          "Unexpected result"
          , { index : int
            ; verifier_status =
                Determined
                  { condition : Condition.t; expected_result : bool; result : bool }
            }]
  | Undetermined { remaining_criteria } ->
    let%bind verifier_status =
      let remaining_conditions =
        Nonempty_list.filter remaining_criteria ~f:(fun { index = _; condition } ->
          Bool.equal result (Condition.evaluate condition ~code))
      in
      match remaining_conditions with
      | [ condition ] -> return (Verifier_status.Determined condition)
      | hd :: (_ :: _ as tl) ->
        return (Verifier_status.Undetermined { remaining_criteria = hd :: tl })
      | [] ->
        Or_error.error_s
          [%sexp
            "Unexpected result"
            , "Verifier has no remaining possible condition"
            , { index : int }]
    in
    let slots =
      Array.Permissioned.mapi t.slots ~f:(fun i slot ->
        if i = index then { slot with Slot.verifier_status } else slot)
    in
    return (create_internal ~slots)
;;

module Criteria_and_probability = struct
  type t =
    { criteria : Criteria.t
    ; probability : float
    }
  [@@deriving equal, sexp_of]
end

let criteria_distribution_exn t ~verifier_name =
  let slot = find_slot_with_verifier_name_exn t ~verifier_name in
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
          = (Array.Permissioned.get hypothesis.verifiers slot.index).criteria.index)
      in
      { Criteria_and_probability.criteria
      ; probability =
          Float.of_int number_of_hypotheses_with_this_criteria /. number_of_hypotheses
      })
;;
