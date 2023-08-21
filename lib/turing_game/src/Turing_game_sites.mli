module Sites : sig
  (** config/ contains a file named [config.sexp] that contains the definition
      of the verifiers needed by the game. *)
  val config : string list
end
