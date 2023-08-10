open! Core

type t = Decoder.t

let v_01 = Decoder.create ~verifiers:Verifiers.[ v_04; v_09; v_11; v_14 ]
let v_02 = Decoder.create ~verifiers:Verifiers.[ v_03; v_07; v_10; v_14 ]
let v_20 = Decoder.create ~verifiers:Verifiers.[ v_11; v_22; v_30; v_33; v_34; v_40 ]

(* Add a new binding for new values here. *)
let all = [ 1, v_01; 2, v_02; 20, v_20 ]

let get_exn i =
  match List.Assoc.find all ~equal:Int.equal i with
  | Some t -> t
  | None ->
    let available = List.map all ~f:fst in
    raise_s [%sexp "Example not available", { i : int; available : int list }]
;;
