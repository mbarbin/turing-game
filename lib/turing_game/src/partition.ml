open! Core

type t = Condition.t array [@@deriving equal, sexp_of]

let verify_counts t =
  with_return (fun { return } ->
    let counts = Array.map t ~f:(fun _ -> ref 0) in
    List.iter (Codes.all |> Codes.to_list) ~f:(fun code ->
      let verifies = Array.map t ~f:(fun condition -> Code.verifies code ~condition) in
      if Array.count verifies ~f:Fn.id <> 1
      then
        return
          (Or_error.error_s
             [%sexp
               "Code does not verify exactly 1 condition"
               , (t : t)
               , { code : Code.t; verifies : bool array }])
      else Array.iteri verifies ~f:(fun i result -> if result then incr counts.(i)));
    let counts = Array.map counts ~f:(fun count -> !count) in
    if Array.exists counts ~f:(fun count -> count = 0)
    then
      return
        (Or_error.error_s
           [%sexp "This partition has empty subsets", (t : t), { counts : int array }]);
    Ok counts)
;;

let verify t =
  let%map.Or_error (_ : int array) = verify_counts t in
  ()
;;

let create t =
  let%map.Or_error () = verify t in
  t
;;

let counts t = verify_counts t |> ok_exn
