open! Core

module Round = struct
  type t =
    { code : Code.t
    ; verifiers : Verifier.Name.t Nonempty_list.t
    }
  [@@deriving compare, equal, hash, sexp_of]
end

type t = { rounds : Round.t Nonempty_list.t } [@@deriving compare, equal, hash, sexp_of]

let number_of_rounds t = Nonempty_list.length t.rounds

module Cost = struct
  type t =
    { number_of_rounds : int
    ; number_of_verifiers : int
    }
  [@@deriving compare, equal, hash, sexp_of]

  let max_value =
    { number_of_rounds = Int.max_value; number_of_verifiers = Int.max_value }
  ;;
end

let cost t =
  let number_of_rounds = number_of_rounds t in
  let number_of_verifiers =
    Nonempty_list.sum
      (module Int)
      t.rounds
      ~f:(fun round -> Nonempty_list.length round.verifiers)
  in
  { Cost.number_of_rounds; number_of_verifiers }
;;

module Compare_by_cost = struct
  type nonrec t = t [@@deriving equal, hash, sexp_of]

  let compare a b =
    let res = Cost.compare (cost a) (cost b) in
    if res <> 0 then res else compare a b
  ;;
end
