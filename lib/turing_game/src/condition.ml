open! Core

type t =
  | Const of bool
  | Equal_value of
      { symbol : Symbol.t
      ; value : Digit.t
      }
  | Greater_than_value of
      { symbol : Symbol.t
      ; value : Digit.t
      }
  | Less_than_value of
      { symbol : Symbol.t
      ; value : Digit.t
      }
  | Equal of
      { a : Symbol.t
      ; b : Symbol.t
      }
  | Greater_than of
      { a : Symbol.t
      ; b : Symbol.t
      }
  | Less_than of
      { a : Symbol.t
      ; b : Symbol.t
      }
  | Has_twins of bool
  | Has_triplets of bool
  | Has_no_triplets_no_twins
  | Less_even_than_odd_digits
  | More_even_than_odd_digits
  | Sum2_equal_value of
      { a : Symbol.t
      ; b : Symbol.t
      ; value : int
      }
  | Sum2_greater_than_value of
      { a : Symbol.t
      ; b : Symbol.t
      ; value : int
      }
  | Sum2_less_than_value of
      { a : Symbol.t
      ; b : Symbol.t
      ; value : int
      }
  | Is_odd of { symbol : Symbol.t }
  | Is_even of { symbol : Symbol.t }
  | Sum_is_even
  | Sum_is_odd
  | Has_digit_count of
      { digit : Digit.t
      ; count : int
      }
  | Is_smallest of { symbol : Symbol.t }
  | Is_smallest_or_equally_smallest of { symbol : Symbol.t }
  | Is_biggest of { symbol : Symbol.t }
  | Is_biggest_or_equally_biggest of { symbol : Symbol.t }
  | Has_odd_digits_count of { count : int }
  | Has_even_digits_count of { count : int }
  | Are_increasing
  | Are_decreasing
  | Are_neither_increasing_nor_decreasing
[@@deriving compare, equal, sexp_of]

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

let evaluate t ~code =
  match (t : t) with
  | Const bool -> bool
  | Equal_value { symbol; value } -> Digit.equal (Symbol.Tuple.get code symbol) value
  | Greater_than_value { symbol; value } ->
    Digit.to_int (Symbol.Tuple.get code symbol) > Digit.to_int value
  | Less_than_value { symbol; value } ->
    Digit.to_int (Symbol.Tuple.get code symbol) < Digit.to_int value
  | Equal { a; b } -> Digit.equal (Symbol.Tuple.get code a) (Symbol.Tuple.get code b)
  | Greater_than { a; b } ->
    Symbol.Tuple.get code a |> Digit.to_int > (Symbol.Tuple.get code b |> Digit.to_int)
  | Less_than { a; b } ->
    Symbol.Tuple.get code a |> Digit.to_int < (Symbol.Tuple.get code b |> Digit.to_int)
  | Has_twins bool -> Bool.equal bool (has_twins code)
  | Has_triplets bool -> Bool.equal bool (has_triplets code)
  | Has_no_triplets_no_twins -> not (has_triplets code || has_twins code)
  | Less_even_than_odd_digits -> even_digits_count code < odd_digits_count code
  | More_even_than_odd_digits -> even_digits_count code > odd_digits_count code
  | Sum2_equal_value { a; b; value } ->
    Digit.to_int (Symbol.Tuple.get code a) + Digit.to_int (Symbol.Tuple.get code b)
    = value
  | Sum2_greater_than_value { a; b; value } ->
    Digit.to_int (Symbol.Tuple.get code a) + Digit.to_int (Symbol.Tuple.get code b)
    > value
  | Sum2_less_than_value { a; b; value } ->
    Digit.to_int (Symbol.Tuple.get code a) + Digit.to_int (Symbol.Tuple.get code b)
    > value
  | Is_odd { symbol } -> Digit.to_int (Symbol.Tuple.get code symbol) % 2 = 1
  | Is_even { symbol } -> Digit.to_int (Symbol.Tuple.get code symbol) % 2 = 0
  | Sum_is_even -> sum code % 2 = 0
  | Sum_is_odd -> sum code % 2 = 1
  | Has_digit_count { digit; count } -> Digit.Tuple.get (digit_counts code) digit = count
  | Is_smallest { symbol } ->
    let value = Symbol.Tuple.get code symbol |> Digit.to_int in
    List.for_all Symbol.all ~f:(fun s ->
      Symbol.equal symbol s || Digit.to_int (Symbol.Tuple.get code s) > value)
  | Is_smallest_or_equally_smallest { symbol } ->
    let value = Symbol.Tuple.get code symbol |> Digit.to_int in
    List.for_all Symbol.all ~f:(fun s -> Digit.to_int (Symbol.Tuple.get code s) >= value)
  | Is_biggest { symbol } ->
    let value = Symbol.Tuple.get code symbol |> Digit.to_int in
    List.for_all Symbol.all ~f:(fun s ->
      Symbol.equal symbol s || Digit.to_int (Symbol.Tuple.get code s) < value)
  | Is_biggest_or_equally_biggest { symbol } ->
    let value = Symbol.Tuple.get code symbol |> Digit.to_int in
    List.for_all Symbol.all ~f:(fun s -> Digit.to_int (Symbol.Tuple.get code s) <= value)
  | Has_odd_digits_count { count } -> odd_digits_count code = count
  | Has_even_digits_count { count } -> even_digits_count code = count
  | Are_increasing -> are_increasing code
  | Are_decreasing -> are_decreasing code
  | Are_neither_increasing_nor_decreasing ->
    not (are_increasing code || are_decreasing code)
;;
