open! Core

type t =
  | Const of bool
  | Compare_symbol_with_value of
      { symbol : Symbol.t
      ; ordering : Ordering.t
      ; value : Digit.t
      }
  | Compare_symbols of
      { a : Symbol.t
      ; ordering : Ordering.t
      ; b : Symbol.t
      }
  | Has_twins of bool
  | Has_triplets of bool
  | Has_no_triplets_no_twins
  | Less_even_than_odd_digits
  | More_even_than_odd_digits
  | Compare_sum_with_value of
      { symbols : Symbol.t list
      ; ordering : Ordering.t
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
  | Compare_symbol_with_others of
      { symbol : Symbol.t
      ; orderings : Ordering.t list
      }
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
  | Compare_symbol_with_value { symbol; ordering; value } ->
    Ordering.equal
      ordering
      (Digit.compare (Symbol.Tuple.get code symbol) value |> Ordering.of_int)
  | Compare_symbols { a; ordering; b } ->
    Ordering.equal
      ordering
      (Digit.compare (Symbol.Tuple.get code a) (Symbol.Tuple.get code b)
       |> Ordering.of_int)
  | Has_twins bool -> Bool.equal bool (has_twins code)
  | Has_triplets bool -> Bool.equal bool (has_triplets code)
  | Has_no_triplets_no_twins -> not (has_triplets code || has_twins code)
  | Less_even_than_odd_digits -> even_digits_count code < odd_digits_count code
  | More_even_than_odd_digits -> even_digits_count code > odd_digits_count code
  | Compare_sum_with_value { symbols; ordering; value } ->
    let sum =
      List.sum
        (module Int)
        symbols
        ~f:(fun symbol -> Digit.to_int (Symbol.Tuple.get code symbol))
    in
    Ordering.equal ordering (Int.compare sum value |> Ordering.of_int)
  | Is_odd { symbol } -> Digit.to_int (Symbol.Tuple.get code symbol) % 2 = 1
  | Is_even { symbol } -> Digit.to_int (Symbol.Tuple.get code symbol) % 2 = 0
  | Sum_is_even -> sum code % 2 = 0
  | Sum_is_odd -> sum code % 2 = 1
  | Has_digit_count { digit; count } -> Digit.Tuple.get (digit_counts code) digit = count
  | Compare_symbol_with_others { symbol; orderings } ->
    let value = Symbol.Tuple.get code symbol in
    List.for_all Symbol.all ~f:(fun s ->
      Symbol.equal symbol s
      ||
      let ordering = Digit.compare value (Symbol.Tuple.get code s) |> Ordering.of_int in
      List.exists orderings ~f:(fun o -> Ordering.equal o ordering))
  | Has_odd_digits_count { count } -> odd_digits_count code = count
  | Has_even_digits_count { count } -> even_digits_count code = count
  | Are_increasing -> are_increasing code
  | Are_decreasing -> are_decreasing code
  | Are_neither_increasing_nor_decreasing ->
    not (are_increasing code || are_decreasing code)
;;
