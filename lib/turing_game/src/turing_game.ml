open! Core
module Code = Code
module Codes = Codes
module Condition = Condition
module Decoder = Decoder
module Decoders = Decoders
module Digit = Digit
module Digits = Digits
module Interactive_solver = Interactive_solver
module Partition = Partition
module Resolution_path = Resolution_path
module Symbol = Symbol
module Verifier = Verifier
module Verifiers = Verifiers

let main = Command.group ~summary:"" [ "solver", Interactive_solver.cmd ]
