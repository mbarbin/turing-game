open! Core
module Code = Code
module Codes = Codes
module Condition = Condition
module Digit = Digit
module Digits = Digits
module Partition = Partition
module Symbol = Symbol

let hello_world = [%sexp "Hello, World!"]

let print_cmd =
  Command.basic
    ~summary:"print hello world"
    (let%map_open.Command () = return () in
     fun () -> print_s hello_world)
;;

let main = Command.group ~summary:"" [ "print", print_cmd ]
