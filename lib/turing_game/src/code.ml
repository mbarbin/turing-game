open! Core

type t = Digit.t Symbol.Tuple.t [@@deriving compare, equal, hash, sexp_of]

let sexp_of_t { Symbol.Tuple.triangle; square; circle } =
  Sexp.Atom
    (sprintf "%d%d%d" (Digit.to_int triangle) (Digit.to_int square) (Digit.to_int circle))
;;

let digit_counts t =
  let counts = Digit.Tuple.init ~f:(fun _ -> ref 0) in
  Symbol.Tuple.iter t ~f:(fun digit -> Digit.Tuple.get counts digit |> incr);
  Digit.Tuple.map counts ~f:(fun t -> t.contents)
;;

let has_twins t = Digit.Tuple.exists (digit_counts t) ~f:(fun count -> count = 2)
let has_triplets t = Digit.Tuple.exists (digit_counts t) ~f:(fun count -> count = 3)

let odd_digits_count t =
  let count = ref 0 in
  Symbol.Tuple.iter t ~f:(fun digit -> if Digit.to_int digit % 2 = 1 then incr count);
  !count
;;

let even_digits_count t =
  let count = ref 0 in
  Symbol.Tuple.iter t ~f:(fun digit -> if Digit.to_int digit % 2 = 0 then incr count);
  !count
;;

let sum t =
  let sum = ref 0 in
  Symbol.Tuple.iter t ~f:(fun digit -> sum := !sum + Digit.to_int digit);
  !sum
;;

let are_increasing { Symbol.Tuple.triangle; square; circle } =
  Digit.to_int triangle < Digit.to_int square && Digit.to_int square < Digit.to_int circle
;;

let are_decreasing { Symbol.Tuple.triangle; square; circle } =
  Digit.to_int triangle > Digit.to_int square && Digit.to_int square > Digit.to_int circle
;;

let verifies t ~condition =
  match (condition : Condition.t) with
  | Const bool -> bool
  | Equal_value { symbol; value } -> Digit.equal (Symbol.Tuple.get t symbol) value
  | Greater_than_value { symbol; value } ->
    Digit.to_int (Symbol.Tuple.get t symbol) > Digit.to_int value
  | Less_than_value { symbol; value } ->
    Digit.to_int (Symbol.Tuple.get t symbol) < Digit.to_int value
  | Equal { a; b } -> Digit.equal (Symbol.Tuple.get t a) (Symbol.Tuple.get t b)
  | Greater_than { a; b } ->
    Symbol.Tuple.get t a |> Digit.to_int > (Symbol.Tuple.get t b |> Digit.to_int)
  | Less_than { a; b } ->
    Symbol.Tuple.get t a |> Digit.to_int < (Symbol.Tuple.get t b |> Digit.to_int)
  | Has_twins bool -> Bool.equal bool (has_twins t)
  | Has_triplets bool -> Bool.equal bool (has_triplets t)
  | Has_no_triplets_no_twins -> not (has_triplets t || has_twins t)
  | Less_even_than_odd_digits -> even_digits_count t < odd_digits_count t
  | More_even_than_odd_digits -> even_digits_count t > odd_digits_count t
  | Sum2_equal_value { a; b; value } ->
    Digit.to_int (Symbol.Tuple.get t a) + Digit.to_int (Symbol.Tuple.get t b)
    = Digit.to_int value
  | Sum2_greater_than_value { a; b; value } ->
    Digit.to_int (Symbol.Tuple.get t a) + Digit.to_int (Symbol.Tuple.get t b)
    > Digit.to_int value
  | Sum2_less_than_value { a; b; value } ->
    Digit.to_int (Symbol.Tuple.get t a) + Digit.to_int (Symbol.Tuple.get t b)
    > Digit.to_int value
  | Is_odd { symbol } -> Digit.to_int (Symbol.Tuple.get t symbol) % 2 = 1
  | Is_even { symbol } -> Digit.to_int (Symbol.Tuple.get t symbol) % 2 = 0
  | Sum_is_even -> sum t % 2 = 0
  | Sum_is_odd -> sum t % 2 = 1
  | Has_digit_count { digit; count } -> Digit.Tuple.get (digit_counts t) digit = count
  | Is_smallest { symbol } ->
    let value = Symbol.Tuple.get t symbol |> Digit.to_int in
    List.for_all Symbol.all ~f:(fun s ->
      Symbol.equal symbol s || Digit.to_int (Symbol.Tuple.get t s) > value)
  | Is_smallest_or_equally_smallest { symbol } ->
    let value = Symbol.Tuple.get t symbol |> Digit.to_int in
    List.for_all Symbol.all ~f:(fun s -> Digit.to_int (Symbol.Tuple.get t s) >= value)
  | Is_biggest { symbol } ->
    let value = Symbol.Tuple.get t symbol |> Digit.to_int in
    List.for_all Symbol.all ~f:(fun s ->
      Symbol.equal symbol s || Digit.to_int (Symbol.Tuple.get t s) < value)
  | Is_biggest_or_equally_biggest { symbol } ->
    let value = Symbol.Tuple.get t symbol |> Digit.to_int in
    List.for_all Symbol.all ~f:(fun s -> Digit.to_int (Symbol.Tuple.get t s) <= value)
  | Has_odd_digits_count { count } -> odd_digits_count t = count
  | Has_even_digits_count { count } -> even_digits_count t = count
  | Are_increasing -> are_increasing t
  | Are_decreasing -> are_decreasing t
  | Are_neither_increasing_nor_decreasing -> not (are_increasing t || are_decreasing t)
;;
