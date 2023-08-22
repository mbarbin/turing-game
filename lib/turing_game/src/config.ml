open! Core

module Game = struct
  type t =
    { name : string
    ; verifiers : int Nonempty_list.t
    }
  [@@deriving sexp]
end

type t =
  { verifiers : Verifier.t list
  ; games : Game.t list
  }
[@@deriving sexp]

let verifiers = ref []
let add_verifier verifier = verifiers := verifier :: !verifiers

let find_config_file_exn () =
  let sites = Turing_game_sites.Sites.config in
  let basename = "config.sexp" in
  sites
  |> List.find_map ~f:(fun config_directory ->
    let file = Filename.concat config_directory basename in
    if Sys_unix.file_exists_exn file then Some file else None)
  |> function
  | Some file -> file
  | None ->
    raise_s [%sexp "Config file not found", { basename : string; sites : string list }]
;;

let load_exn () =
  let config_file = find_config_file_exn () in
  Sexp.load_sexp_conv_exn config_file t_of_sexp
;;

let find_verifier_exn t ~index =
  match List.find t.verifiers ~f:(fun verifier -> index = verifier.index) with
  | Some verifier -> verifier
  | None -> raise_s [%sexp "Verifier not found", { index : int }]
;;

let find_game_exn t ~name =
  match List.find t.games ~f:(fun game -> String.equal name game.name) with
  | None ->
    raise_s [%sexp "Game not found", { games = (t.games : Game.t list); name : string }]
  | Some game ->
    let verifiers =
      Nonempty_list.map game.verifiers ~f:(fun index -> find_verifier_exn t ~index)
    in
    Decoder.create ~verifiers
;;
