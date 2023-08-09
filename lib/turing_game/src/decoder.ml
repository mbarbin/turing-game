open! Core

module Verifier = struct
  type t =
    { name : string
    ; conditions : Condition.t Nonempty_list.t
    }
  [@@deriving equal, sexp_of]

  let create ~name ~conditions = { name; conditions }
end

module Slot = struct
  module Status = struct
    type t =
      | Undetermined of { remaining_conditions : Condition.t Nonempty_list.t }
      | Determined of { condition : Condition.t }
    [@@deriving equal, sexp_of]
  end

  type t =
    { index : int
    ; verifier : Verifier.t
    ; status : Status.t
    }
  [@@deriving equal, sexp_of]
end

type t = { slots : (Slot.t, immutable) Array.Permissioned.t } [@@deriving sexp_of]

let add_test_result_exn t ~verifier ~code ~result =
  let slot =
    match
      Array.Permissioned.find t.slots ~f:(fun slot -> phys_equal verifier slot.verifier)
    with
    | Some slot -> slot
    | None -> raise_s [%sexp "Verifier not found in t", { verifier : Verifier.t }]
  in
  let index = slot.index in
  match slot.status with
  | Determined { condition } ->
    (* Nothing to learn. *)
    let expected_result = Code.verifies code ~condition in
    if not (Bool.equal expected_result result)
    then
      raise_s
        [%sexp
          "Unexpected result"
          , { index : int
            ; verifier_status =
                Determined
                  { condition : Condition.t; expected_result : bool; result : bool }
            }];
    t
  | Undetermined { remaining_conditions } ->
    let status =
      let remaining_conditions =
        Nonempty_list.filter remaining_conditions ~f:(fun condition ->
          Bool.equal result (Code.verifies code ~condition))
      in
      match remaining_conditions with
      | [ condition ] -> Slot.Status.Determined { condition }
      | hd :: (_ :: _ as tl) ->
        Slot.Status.Undetermined { remaining_conditions = hd :: tl }
      | [] ->
        raise_s
          [%sexp
            "Unexpected result"
            , "Verifier has no remaining possible condition"
            , { index : int }]
    in
    { slots =
        Array.Permissioned.mapi t.slots ~f:(fun i slot ->
          if i = index then { slot with Slot.status } else slot)
    }
;;

let create ~verifiers =
  { slots =
      verifiers
      |> Nonempty_list.to_array
      |> Array.Permissioned.of_array_id
      |> Array.Permissioned.mapi ~f:(fun index verifier ->
        { Slot.index
        ; verifier
        ; status = Undetermined { remaining_conditions = verifier.conditions }
        })
  }
;;

let verifiers t =
  t.slots
  |> Array.Permissioned.to_list
  |> List.map ~f:(fun slot -> slot.verifier)
  |> Nonempty_list.of_list_exn
;;

(* An hypothesis on the nature of verifiers means choosing one single condition
   for each verifier, as well as a result for it. For each hypothesis, we may
   construct the set of codes that verify such condition. If that set is not a
   singleton, we can discard that hypothesis.

   Are there hypotheses that are more probable than others?

   Or are we rather trying to propose tests to run such that they remove the
   most hypothesis?

   A proposal is a code to run through a verifier, which gives back a result.
   Once we have applied that result, we are left with a state that has a
   remaining number of hypothesis.
*)

module Hypothesis = struct
  module One_verifier = struct
    type t =
      { name : string
      ; condition : Condition.t
      }
    [@@deriving equal, sexp_of]

    let remaining_codes t ~remaining_codes =
      Codes.filter remaining_codes ~f:(fun code ->
        Code.verifies code ~condition:t.condition)
    ;;
  end

  type t =
    { verifiers : (One_verifier.t, immutable) Array.Permissioned.t
    ; number_of_remaining_codes : int [@sexp_drop_if ( = ) 1]
    ; remaining_codes : Codes.t (* Must be non empty. *)
    }

  let sexp_of_t { verifiers; number_of_remaining_codes; remaining_codes } =
    match remaining_codes |> Codes.to_list with
    | [ code ] ->
      [%sexp
        { code : Code.t; verifiers : (One_verifier.t, immutable) Array.Permissioned.t }]
    | _ ->
      [%sexp
        { number_of_remaining_codes : int
        ; verifiers : (One_verifier.t, immutable) Array.Permissioned.t
        }]
  ;;
end

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

let hypotheses ?(strict = true) (t : t) =
  let verifiers : Hypothesis.One_verifier.t Queue.t array =
    Array.init (Array.Permissioned.length t.slots) ~f:(fun _ -> Queue.create ())
  in
  Array.Permissioned.iteri t.slots ~f:(fun i slot ->
    let name = slot.verifier.name in
    match slot.status with
    | Undetermined { remaining_conditions } ->
      Nonempty_list.iter remaining_conditions ~f:(fun condition ->
        Queue.enqueue verifiers.(i) { name; condition })
    | Determined { condition } -> Queue.enqueue verifiers.(i) { name; condition });
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
