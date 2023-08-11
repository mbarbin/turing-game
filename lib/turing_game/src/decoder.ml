open! Core

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

module Test_results = struct
  module Key = struct
    type t =
      { code : Code.t
      ; verifier : Verifier.Name.t
      }
    [@@deriving compare, equal, hash, sexp_of]
  end

  module T = struct
    type t = bool array [@@deriving compare, equal, sexp_of]
  end

  include T
  include Comparator.Make (T)
end

module Hypothesis = struct
  module One_verifier = struct
    type t =
      { name : Verifier.Name.t
      ; condition : Condition.t
      }
    [@@deriving equal, sexp_of]

    let remaining_codes t ~remaining_codes =
      Codes.filter remaining_codes ~f:(fun code -> Condition.evaluate t.condition ~code)
    ;;
  end

  type t =
    { verifiers : (One_verifier.t, immutable) Array.Permissioned.t
    ; number_of_remaining_codes : int
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

  let verifier_exn t ~name =
    t.verifiers
    |> Array.Permissioned.to_list
    |> List.find_map_exn ~f:(fun verifier ->
      Option.some_if (Verifier.Name.equal name verifier.name) verifier.condition)
  ;;

  let remaining_code_exn t =
    match t.remaining_codes |> Codes.to_list with
    | [ code ] -> code
    | [] | _ :: _ :: _ ->
      raise_s
        [%sexp "Hypothesis is expected to have a unique remaining code", [%here], (t : t)]
  ;;

  let remaining_codes t = t.remaining_codes

  let evaluate_exn t ~code ~verifier =
    let condition = verifier_exn t ~name:verifier in
    Condition.evaluate condition ~code
  ;;
end

type t =
  { slots : (Slot.t, immutable) Array.Permissioned.t
  ; mutable strict_hypotheses : Hypothesis.t list option
  }
[@@deriving sexp_of]

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
  ; strict_hypotheses = None
  }
;;

let verifiers t =
  t.slots
  |> Array.Permissioned.to_list
  |> List.map ~f:(fun slot -> slot.verifier)
  |> Nonempty_list.of_list_exn
;;

let verifier_exn t ~name =
  t.slots
  |> Array.Permissioned.to_list
  |> List.find_map_exn ~f:(fun slot ->
    Option.some_if (Verifier.Name.equal name slot.verifier.name) slot.verifier)
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

let number_of_remaining_codes t = hypotheses t ~strict:true |> List.length

let remaining_codes t =
  hypotheses t ~strict:true |> List.map ~f:Hypothesis.remaining_codes |> Codes.concat
;;

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
  match slot.status with
  | Determined { condition } ->
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
  | Undetermined { remaining_conditions } ->
    let%bind status =
      let remaining_conditions =
        Nonempty_list.filter remaining_conditions ~f:(fun condition ->
          Bool.equal result (Condition.evaluate condition ~code))
      in
      match remaining_conditions with
      | [ condition ] -> return (Slot.Status.Determined { condition })
      | hd :: (_ :: _ as tl) ->
        return (Slot.Status.Undetermined { remaining_conditions = hd :: tl })
      | [] ->
        Or_error.error_s
          [%sexp
            "Unexpected result"
            , "Verifier has no remaining possible condition"
            , { index : int }]
    in
    let t =
      { slots =
          Array.Permissioned.mapi t.slots ~f:(fun i slot ->
            if i = index then { slot with Slot.status } else slot)
      ; strict_hypotheses = None
      }
    in
    Or_error.return t
;;

let compute_test_results t ~keys =
  List.map (hypotheses t ~strict:true) ~f:(fun hypothesis ->
    let test_results =
      Array.map keys ~f:(fun { Test_results.Key.code; verifier } ->
        Hypothesis.evaluate_exn hypothesis ~code ~verifier)
    in
    test_results, hypothesis)
;;
