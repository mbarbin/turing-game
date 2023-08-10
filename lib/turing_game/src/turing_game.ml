open! Core
module Code = Code
module Codes = Codes
module Condition = Condition
module Decoder = Decoder
module Digit = Digit
module Digits = Digits
module Partition = Partition
module Resolution_path = Resolution_path
module Solver = Solver
module Symbol = Symbol
module Verifier = Verifier

let hello_world = [%sexp "Hello, World!"]

let print_cmd =
  Command.basic
    ~summary:"print hello world"
    (let%map_open.Command () = return () in
     fun () -> print_s hello_world)
;;

let solver_example_cmd =
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
         | 1 ->
           Decoder.create
             ~verifiers:
               Verifier.Examples.[ verifier_04; verifier_09; verifier_11; verifier_14 ]
         | 20 ->
           Decoder.create
             ~verifiers:
               Verifier.Examples.
                 [ verifier_11
                 ; verifier_22
                 ; verifier_30
                 ; verifier_33
                 ; verifier_34
                 ; verifier_40
                 ]
         | n ->
           raise_s [%sexp "Example not available", { n : int; available = [ 1; 20 ] }]
       in
       let solutions =
         Ref.set_temporarily Solver.debug true ~f:(fun () ->
           if quick_solve
           then Solver.quick_solve ~decoder |> Option.to_list
           else Solver.solve ~decoder ~visit_all_children)
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
    ; "solver", Command.group ~summary:"solver" [ "example", solver_example_cmd ]
    ]
;;
