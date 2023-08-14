open! Core

module Name = struct
  type t = string [@@deriving compare, equal, hash, sexp_of]
end

type t =
  { name : Name.t
  ; criteria : Criteria.t Nonempty_list.t
  }
[@@deriving compare, equal, sexp_of]

let create ~name ~conditions =
  let criteria =
    Nonempty_list.mapi conditions ~f:(fun index condition ->
      { Criteria.index; condition })
  in
  { name; criteria }
;;
