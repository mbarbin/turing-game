let () =
  Cmdlang_cmdliner_runner.run Turing_game.main ~name:"turing-game" ~version:"%%VERSION%%"
;;
