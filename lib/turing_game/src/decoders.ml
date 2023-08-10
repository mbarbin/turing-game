open! Core

type t = Decoder.t

let v_01 = Decoder.create ~verifiers:Verifiers.[ v_04; v_09; v_11; v_14 ]
let v_20 = Decoder.create ~verifiers:Verifiers.[ v_11; v_22; v_30; v_33; v_34; v_40 ]

let get_exn = function
  | 1 -> v_01
  | 20 -> v_20
  | n -> raise_s [%sexp "Example not available", { n : int; available = [ 1; 20 ] }]
;;
