let () =
  Cmdliner.Cmd.eval
    (Commandlang_to_cmdliner.Translate.command
       Turing_game.main
       ~name:"turing-game"
       ~version:"%%VERSION%%")
  |> Stdlib.exit
;;
