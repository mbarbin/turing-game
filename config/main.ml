open! Core
open! Turing_game

module Verifiers = struct
  let all = ref []

  let create ~index ~conditions =
    let verifier = { Verifier.index; conditions } in
    all := verifier :: !all;
    verifier
  ;;

  let v_03 =
    create
      ~index:3
      ~conditions:
        [ Less_than_value { symbol = Square; value = Three }
        ; Equal_value { symbol = Square; value = Three }
        ; Greater_than_value { symbol = Square; value = Three }
        ]
  ;;

  let v_04 =
    create
      ~index:4
      ~conditions:
        [ Less_than_value { symbol = Square; value = Four }
        ; Equal_value { symbol = Square; value = Four }
        ; Greater_than_value { symbol = Square; value = Four }
        ]
  ;;

  let v_05 =
    create
      ~index:5
      ~conditions:[ Is_even { symbol = Triangle }; Is_odd { symbol = Triangle } ]
  ;;

  let v_07 =
    create
      ~index:7
      ~conditions:[ Is_even { symbol = Circle }; Is_odd { symbol = Circle } ]
  ;;

  let v_08 =
    create
      ~index:8
      ~conditions:
        (List.init 4 ~f:(fun count -> Condition.Has_digit_count { digit = One; count })
         |> Nonempty_list.of_list_exn)
  ;;

  let v_09 =
    create
      ~index:9
      ~conditions:
        (List.init 4 ~f:(fun count -> Condition.Has_digit_count { digit = Three; count })
         |> Nonempty_list.of_list_exn)
  ;;

  let v_10 =
    create
      ~index:10
      ~conditions:
        [ Has_digit_count { digit = Four; count = 0 }
        ; Has_digit_count { digit = Four; count = 1 }
        ; Has_digit_count { digit = Four; count = 2 }
        ; Has_digit_count { digit = Four; count = 3 }
        ]
  ;;

  let v_11 =
    create
      ~index:11
      ~conditions:
        [ Less_than { a = Triangle; b = Square }
        ; Equal { a = Triangle; b = Square }
        ; Greater_than { a = Triangle; b = Square }
        ]
  ;;

  let v_12 =
    create
      ~index:12
      ~conditions:
        [ Less_than { a = Triangle; b = Circle }
        ; Equal { a = Triangle; b = Circle }
        ; Greater_than { a = Triangle; b = Circle }
        ]
  ;;

  let v_14 =
    create
      ~index:14
      ~conditions:
        [ Is_smallest { symbol = Triangle }
        ; Is_smallest { symbol = Square }
        ; Is_smallest { symbol = Circle }
        ]
  ;;

  let v_18 = create ~index:18 ~conditions:[ Sum_is_odd; Sum_is_even ]

  let v_19 =
    create
      ~index:19
      ~conditions:
        [ Sum2_less_than_value { a = Triangle; b = Square; value = 6 }
        ; Sum2_equal_value { a = Triangle; b = Square; value = 6 }
        ; Sum2_greater_than_value { a = Triangle; b = Square; value = 6 }
        ]
  ;;

  let v_20 =
    create
      ~index:20
      ~conditions:[ Has_triplets true; Has_twins true; Has_no_triplets_no_twins ]
  ;;

  let v_21 = create ~index:21 ~conditions:[ Has_twins false; Has_twins true ]

  let v_22 =
    create
      ~index:22
      ~conditions:
        [ Are_increasing; Are_decreasing; Are_neither_increasing_nor_decreasing ]
  ;;

  let v_30 =
    create
      ~index:30
      ~conditions:
        [ Equal_value { symbol = Triangle; value = Four }
        ; Equal_value { symbol = Square; value = Four }
        ; Equal_value { symbol = Circle; value = Four }
        ]
  ;;

  let v_33 =
    create
      ~index:33
      ~conditions:
        [ Is_even { symbol = Triangle }
        ; Is_even { symbol = Square }
        ; Is_even { symbol = Circle }
        ]
  ;;

  let v_34 =
    create
      ~index:34
      ~conditions:
        [ Is_smallest_or_equally_smallest { symbol = Triangle }
        ; Is_smallest_or_equally_smallest { symbol = Square }
        ; Is_smallest_or_equally_smallest { symbol = Circle }
        ]
  ;;

  let v_40 =
    create
      ~index:40
      ~conditions:
        (Symbol.all
         |> Nonempty_list.of_list_exn
         |> Nonempty_list.concat_map ~f:(fun symbol ->
           Condition.
             [ Less_than_value { symbol; value = Three }
             ; Equal_value { symbol; value = Three }
             ; Greater_than_value { symbol; value = Three }
             ]))
  ;;
end

module Games = struct
  let all = ref []

  let create ~name ~verifiers =
    let decoder = Decoder.create ~verifiers in
    let verifiers =
      Decoder.verifiers decoder
      |> Nonempty_list.map ~f:(fun verifier -> verifier.Verifier.index)
    in
    all := { Config.Game.name; verifiers } :: !all
  ;;

  let () = create ~name:"01" ~verifiers:Verifiers.[ v_04; v_09; v_11; v_14 ]
  let () = create ~name:"02" ~verifiers:Verifiers.[ v_03; v_07; v_10; v_14 ]
  let () = create ~name:"15" ~verifiers:Verifiers.[ v_05; v_14; v_18; v_19; v_20 ]
  let () = create ~name:"20" ~verifiers:Verifiers.[ v_11; v_22; v_30; v_33; v_34; v_40 ]

  (* online *)

  let () = create ~name:"401" ~verifiers:Verifiers.[ v_03; v_07; v_08; v_12; v_21 ]
  let () = create ~name:"402" ~verifiers:Verifiers.[ v_04; v_05; v_08; v_14; v_20 ]
end

let gen_config_cmd =
  Command.basic
    ~summary:"output config"
    (let%map_open.Command () = return () in
     fun () ->
       let config =
         { Config.verifiers = Verifiers.all.contents |> List.rev
         ; games = Games.all.contents |> List.rev
         }
       in
       print_s [%sexp (config : Config.t)])
;;

let cmd = Command.group ~summary:"config commands" [ "gen-config", gen_config_cmd ]
let () = Command_unix.run cmd
