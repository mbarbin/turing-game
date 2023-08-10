open! Core
module Code = Code
module Codes = Codes
module Complete_solver = Complete_solver
module Condition = Condition
module Decoder = Decoder
module Digit = Digit
module Digits = Digits
module Interactive_solver = Interactive_solver
module Partition = Partition
module Resolution_path = Resolution_path
module Symbol = Symbol
module Verifier = Verifier
module Verifiers = Verifiers

let hello_world = [%sexp "Hello, World!"]

let print_cmd =
  Command.basic
    ~summary:"print hello world"
    (let%map_open.Command () = return () in
     fun () -> print_s hello_world)
;;

let complete_solver_example_cmd =
  Command.basic
    ~summary:"solve an example"
    (let%map_open.Command n =
       flag "n" (optional_with_default 1 int) ~doc:"N example number (1-20)"
     and visit_all_children =
       flag
         "visit-all-children"
         (optional_with_default true bool)
         ~doc:"bool when false only consider best children at each depth"
     and quick_solve =
       flag "quick-solve" no_arg ~doc:" quickly find a solution maybe not optimal"
     in
     fun () ->
       let decoder =
         match n with
         | 1 -> Decoder.create ~verifiers:Verifiers.[ v_04; v_09; v_11; v_14 ]
         | 20 ->
           Decoder.create ~verifiers:Verifiers.[ v_11; v_22; v_30; v_33; v_34; v_40 ]
         | n ->
           raise_s [%sexp "Example not available", { n : int; available = [ 1; 20 ] }]
       in
       let solutions =
         Ref.set_temporarily Complete_solver.debug true ~f:(fun () ->
           if quick_solve
           then Complete_solver.quick_solve ~decoder |> Option.to_list
           else Complete_solver.solve ~decoder ~visit_all_children)
       in
       print_s
         [%sexp
           { solutions : Resolution_path.t list
           ; number_of_solutions = (List.length solutions : int)
           }];
       ())
;;

let main =
  Command.group
    ~summary:""
    [ "print", print_cmd
    ; ( "complete-solver"
      , Command.group ~summary:"solver" [ "example", complete_solver_example_cmd ] )
    ]
;;
