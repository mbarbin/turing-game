open! Core

(** A resolution_path is said to be complete if it forces the resolution down to
    a single remaining hypothesis. *)
val is_complete_resolution_path
  :  decoder:Decoder.t
  -> resolution_path:Resolution_path.t
  -> bool

(** Find and return all strict subpath of a given resolution path that are
    complete, if any exists. The returned resolution paths verify the added
    condition that they may not be further shrunk (they are minimal). *)
val shrink_resolution_path
  :  decoder:Decoder.t
  -> resolution_path:Resolution_path.t
  -> Resolution_path.t list
