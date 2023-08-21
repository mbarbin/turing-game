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
