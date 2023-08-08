open! Core

type t = Code.t list [@@deriving equal, compare, sexp_of]

let empty = []
let to_list t = t

let all =
  let open List.Let_syntax in
  let%bind triangle = Digit.all in
  let%bind square = Digit.all in
  let%bind circle = Digit.all in
  [ { Symbol.Tuple.triangle; square; circle } ]
;;

let mem t (code : Code.t) = List.mem t code ~equal:Code.equal
let init ~f = List.filter all ~f
let verifies t ~condition = List.filter t ~f:(fun code -> Code.verifies code ~condition)
let filter t ~f = List.filter t ~f
let length t = List.length t
