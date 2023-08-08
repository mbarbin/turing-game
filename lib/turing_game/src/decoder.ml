open! Core

module Verifier = struct
  type t = Condition.t list [@@deriving equal, sexp_of]

  let create t = t
end

module Verifier_status = struct
  type t =
    | Undetermined of { remaining_conditions : Condition.t list }
    | Determined of { condition : Condition.t }
  [@@deriving equal, sexp_of]
end

type t =
  { verifiers : Verifier.t array
  ; verifiers_status : Verifier_status.t array
  }
[@@deriving equal, sexp_of]

let add_test_result_exn t ~verifier ~code ~result =
  let i =
    Array.find_mapi_exn t.verifiers ~f:(fun i v ->
      if phys_equal verifier v then Some i else None)
  in
  match t.verifiers_status.(i) with
  | Determined { condition } ->
    (* Nothing to learn. *)
    let expected_result = Code.verifies code ~condition in
    if not (Bool.equal expected_result result)
    then
      raise_s
        [%sexp
          "Unexpected result"
          , { verifier_status =
                Determined
                  { condition : Condition.t; expected_result : bool; result : bool }
            }]
  | Undetermined { remaining_conditions } ->
    let remaining_conditions =
      List.filter remaining_conditions ~f:(fun condition ->
        Bool.equal result (Code.verifies code ~condition))
    in
    (match remaining_conditions with
     | [ condition ] -> t.verifiers_status.(i) <- Determined { condition }
     | _ :: _ :: _ -> t.verifiers_status.(i) <- Undetermined { remaining_conditions }
     | [] ->
       raise_s [%sexp "Unexpected result", "Verifier has no remaining possible condition"])
;;

let create verifiers =
  let verifiers = Array.of_list verifiers in
  { verifiers
  ; verifiers_status =
      Array.map verifiers ~f:(fun remaining_conditions ->
        Verifier_status.Undetermined { remaining_conditions })
  }
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
      { id : Verifier.t
      ; condition : Condition.t
      }
    [@@deriving equal, sexp_of]

    module Short_sexp = struct
      let sexp_of_t { id = _; condition } = [%sexp (condition : Condition.t)]
    end

    let remaining_codes t ~remaining_codes =
      Codes.filter remaining_codes ~f:(fun code ->
        Code.verifies code ~condition:t.condition)
    ;;
  end

  type t =
    { verifiers : One_verifier.t array
    ; number_of_remaining_codes : int
    ; remaining_codes : Codes.t (* Must be non empty. *)
    }
  [@@deriving equal, sexp_of]

  module Short_sexp = struct
    type nonrec t = t

    let sexp_of_t { verifiers; number_of_remaining_codes; remaining_codes = _ } =
      [%sexp
        { verifiers : One_verifier.Short_sexp.t array; number_of_remaining_codes : int }]
    ;;
  end
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

let hypotheses t =
  let verifiers : Hypothesis.One_verifier.t Queue.t Array.t =
    Array.map t.verifiers_status ~f:(fun _ -> Queue.create ())
  in
  Array.iteri t.verifiers_status ~f:(fun i verifier_status ->
    let id = t.verifiers.(i) in
    match verifier_status with
    | Undetermined { remaining_conditions } ->
      List.iter remaining_conditions ~f:(fun condition ->
        Queue.enqueue verifiers.(i) { id; condition })
    | Determined { condition } -> Queue.enqueue verifiers.(i) { id; condition });
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
      Array.map verifiers ~f:(fun { Cycle_counter.values; current_value } ->
        values.(current_value))
    in
    let remaining_codes =
      Array.fold verifiers ~init:Codes.all ~f:(fun remaining_codes one_verifier ->
        Hypothesis.One_verifier.remaining_codes one_verifier ~remaining_codes)
    in
    let number_of_remaining_codes = Codes.length remaining_codes in
    if number_of_remaining_codes > 0
    then
      Queue.enqueue
        hypotheses
        { Hypothesis.verifiers; number_of_remaining_codes; remaining_codes };
    if incr () then loop ()
  in
  loop ();
  Queue.to_list hypotheses
;;
