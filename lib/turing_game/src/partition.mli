open! Core

type t = private Condition.t array [@@deriving equal, sexp_of]

(** The condition given as an input must properly define a partition of the set
    of all possible codes, otherwise the function will return an Error. To
    properly define a partition, the condition must be such that each code
    verifies exactly one of the input condition, and also that no condition
    yields an empty subset. *)
val create : Condition.t array -> t Or_error.t

(** Go over all possible codes, and count the number of elements resulting in
    each of the subset of the partition. It is guaranteed by construction of
    [t] that each subset has at least 1 element. *)
val counts : t -> int array
