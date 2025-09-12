(*********************************************************************************)
(*  turing-game - A bot that can play a board game called Turing Machine         *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t = Code.t list [@@deriving equal, compare, sexp_of]

module With_sorted_sexp = struct
  type nonrec t = t [@@deriving equal, compare]

  let sexp_of_t (t : t) = List.sort t ~compare:Code.compare |> sexp_of_t
end

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

let rec rev_add seen (acc : _ Reversed_list.t) = function
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
  List.fold ts ~init:([] : _ Reversed_list.t) ~f:(fun acc t -> rev_add seen acc t)
  |> Reversed_list.rev
;;

let append t1 t2 = concat [ t1; t2 ]
let filter = List.filter
let length = List.length
let iter = List.iter
let map = List.map
