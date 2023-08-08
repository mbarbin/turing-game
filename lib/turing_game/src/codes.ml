open! Core

type t = Code.t list [@@deriving equal, compare, sexp_of]

let empty = []

let all =
  let open List.Let_syntax in
  let%bind triangle = Digit.all in
  let%bind square = Digit.all in
  let%bind circle = Digit.all in
  [ { Symbol.Tuple.triangle; square; circle } ]
;;

let mem t (code : Code.t) = List.mem t code ~equal:Code.equal
let init ~f = List.filter all ~f
