type t =
  { verifier : Verifier.t
  ; verifier_letter : Verifier_letter.t
  }
[@@deriving compare, equal, sexp_of]
