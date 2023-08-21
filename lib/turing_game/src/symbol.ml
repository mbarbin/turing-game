open! Core

type t =
  | Triangle
  | Square
  | Circle
[@@deriving compare, enumerate, equal, hash, sexp]

module Color = struct
  type t =
    | Blue
    | Yellow
    | Magenta
  [@@deriving compare, enumerate, equal, hash, sexp_of]
end

let color t : Color.t =
  match (t : t) with
  | Triangle -> Blue
  | Square -> Yellow
  | Circle -> Magenta
;;

module Tuple = struct
  type 'a t =
    { triangle : 'a
    ; square : 'a
    ; circle : 'a
    }
  [@@deriving compare, enumerate, equal, fields, hash, sexp_of]

  let get t symbol =
    match symbol with
    | Triangle -> t.triangle
    | Square -> t.square
    | Circle -> t.circle
  ;;

  let init ~f = { triangle = f Triangle; square = f Square; circle = f Circle }

  let map t ~f =
    let f field = f (Core.Field.get field t) in
    Fields.map ~triangle:f ~square:f ~circle:f
  ;;

  let singleton a = { triangle = a; square = a; circle = a }

  include Applicative.Make (struct
      type nonrec 'a t = 'a t

      let return = singleton

      let apply f y =
        { triangle = f.triangle y.triangle
        ; square = f.square y.square
        ; circle = f.circle y.circle
        }
      ;;

      let map = `Custom map
    end)

  include Container.Make (struct
      type nonrec 'a t = 'a t

      let length = `Custom (fun _ -> 3)

      let fold t ~init ~f =
        let f acc field = f acc (Field.get field t) in
        Fields.fold ~init ~triangle:f ~square:f ~circle:f
      ;;

      let iter =
        `Custom
          (fun t ~f ->
            let f field = f (Field.get field t) in
            Fields.iter ~triangle:f ~square:f ~circle:f)
      ;;
    end)
end

let colors = Tuple.init ~f:color
