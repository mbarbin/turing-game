type t

(** Load the config installed in the system *)
val load_exn : unit -> t

val find_verifier_exn : t -> index:int -> Verifier.t
val decoder_exn : t -> int Nonempty_list.t -> Decoder.t

(** Register API *)

val add_verifier : Verifier.t -> unit
