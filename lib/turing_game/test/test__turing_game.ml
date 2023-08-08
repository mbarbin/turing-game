open! Core

let%expect_test "hello" =
  print_s Turing_game.hello_world;
  [%expect {| "Hello, World!" |}]
;;
