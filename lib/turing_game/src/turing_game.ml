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
    (let%map_open.Command () = return () in
     fun () ->
       let decoder =
         Decoder.create
           ~verifiers:
             Verifier.Examples.[ verifier_04; verifier_09; verifier_11; verifier_14 ]
       in
       let solutions = Solver.solve ~decoder in
       print_s [%sexp (solutions : Resolution_path.t list)];
       ())
;;

let main =
  Command.group
    ~summary:""
    [ "print", print_cmd
    ; "solver", Command.group ~summary:"solver" [ "example", solver_example_cmd ]
    ]
;;
