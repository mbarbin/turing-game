let () =
  Cmdlang_to_cmdliner.run Turing_game.main ~name:"turing-game" ~version:"%%VERSION%%"
;;
