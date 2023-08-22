open! Core

type t =
  | One
  | Two
  | Three
  | Four
  | Five
[@@deriving compare, enumerate, equal, hash]

let to_int = function
  | One -> 1
  | Two -> 2
  | Three -> 3
  | Four -> 4
  | Five -> 5
;;

let sexp_of_t t = [%sexp (to_int t : int)]

module Tuple = struct
  type 'a t =
    { one : 'a
    ; two : 'a
    ; three : 'a
    ; four : 'a
    ; five : 'a
    }
  [@@deriving compare, enumerate, equal, fields, hash, sexp_of]

  let get t digit =
    match digit with
    | One -> t.one
    | Two -> t.two
    | Three -> t.three
    | Four -> t.four
    | Five -> t.five
  ;;

  let init ~f =
    { one = f One; two = f Two; three = f Three; four = f Four; five = f Five }
  ;;

  let map t ~f =
    let f field = f (Core.Field.get field t) in
    Fields.map ~one:f ~two:f ~three:f ~four:f ~five:f
  ;;

  let singleton a = init ~f:(fun _ -> a)

  include Applicative.Make (struct
      type nonrec 'a t = 'a t

      let return = singleton

      let apply f x =
        { one = f.one x.one
        ; two = f.two x.two
        ; three = f.three x.three
        ; four = f.four x.four
        ; five = f.five x.five
        }
      ;;

      let map = `Custom map
    end)

  include Container.Make (struct
      type nonrec 'a t = 'a t

      let length = `Custom (fun _ -> 4)

      let fold t ~init ~f =
        let f acc field = f acc (Field.get field t) in
        Fields.fold ~init ~one:f ~two:f ~three:f ~four:f ~five:f
      ;;

      let iter =
        `Custom
          (fun t ~f ->
            let f field = f (Field.get field t) in
            Fields.iter ~one:f ~two:f ~three:f ~four:f ~five:f)
      ;;
    end)
end
