(** A representation for a set of codes, where each code is unique. This is
    equivalent to a list with no duplicate. *)

type t [@@deriving equal, compare, sexp_of]

module With_sorted_sexp : sig
  (** Sort the elements before creating the sexp. To be used by tests. *)
  type nonrec t = t [@@deriving equal, compare, sexp_of]
end

val empty : t

(** All the combinations of codes that can be used in the game. *)
val all : t

(** Returns [Some code] if code is the unique element of [t], and [None] if [t]
    is empty or has more that 1 element. *)
val is_singleton : t -> Code.t option

(** [append t1 t2] and [concat ts] aggregate values founds in the inputs, while
    skipping elements that have been already seen. *)

val append : t -> t -> t
val concat : t list -> t

(** {1 Operations that are equivalent to that of [List]} *)

val filter : t -> f:(Code.t -> bool) -> t
val length : t -> int
val iter : t -> f:(Code.t -> unit) -> unit
val map : t -> f:(Code.t -> 'a) -> 'a list
