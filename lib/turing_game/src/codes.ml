open! Core

type t = Code.t list [@@deriving equal, compare, sexp_of]

let empty = []

let all =
  (let open List.Let_syntax in
   let%bind triangle = Digit.all in
   let%bind square = Digit.all in
   let%bind circle = Digit.all in
   [ { Symbol.Tuple.triangle; square; circle } ])
  |> List.sort ~compare:Code.compare
;;

let is_singleton = function
  | [ hd ] -> Some hd
  | [] | _ :: _ :: _ -> None
;;

let rec rev_add seen acc = function
  | [] -> acc
  | hd :: tl ->
    let acc =
      if Hash_set.mem seen hd
      then acc
      else (
        Hash_set.add seen hd;
        hd :: acc)
    in
    rev_add seen acc tl
;;

let concat ts =
  let seen = Hash_set.create (module Code) in
  List.fold ts ~init:[] ~f:(fun acc t -> rev_add seen acc t) |> List.rev
;;

let append t1 t2 = concat [ t1; t2 ]
let filter = List.filter
let length = List.length
let iter = List.iter
let map = List.map
