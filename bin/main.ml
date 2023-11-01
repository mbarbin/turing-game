let () =
  Command_unix.run ~version:"%%VERSION%%" ~build_info:"%%VCS_COMMIT_ID%%" Turing_game.main
;;
