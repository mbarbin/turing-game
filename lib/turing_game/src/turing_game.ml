open! Base
module Code = Code
module Codes = Codes
module Predicate = Predicate
module Config = Config
module Criteria = Criteria
module Decoder = Decoder
module Digit = Digit
module Interactive_solver = Interactive_solver
module Resolution_path = Resolution_path
module Symbol = Symbol
module Verifier = Verifier

let main = Command.group ~summary:"" [ "solver", Interactive_solver.cmd ]
