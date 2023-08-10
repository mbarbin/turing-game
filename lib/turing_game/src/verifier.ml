open! Core

module Name = struct
  type t = string [@@deriving compare, equal, hash, sexp_of]
end

type t =
  { name : Name.t
  ; conditions : Condition.t Nonempty_list.t
  }
[@@deriving compare, equal, sexp_of]

let create ~name ~conditions = { name; conditions }
