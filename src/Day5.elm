module Day5 exposing (..)

import Day5Input exposing (input)


codeToNum : String -> Int
codeToNum code =
    let
        lower ( min, max ) rest =
            inner ( min, (max - min) // 2 + min ) rest

        upper ( min, max ) rest =
            inner ( min + ((max - min) // 2) + 1, max ) rest

        inner : ( Int, Int ) -> String -> Int
        inner range row =
            case String.uncons row of
                Just ( 'F', rest ) ->
                    lower range rest

                Just ( 'L', rest ) ->
                    lower range rest

                Just ( 'B', rest ) ->
                    upper range rest

                Just ( 'R', rest ) ->
                    upper range rest

                _ ->
                    Tuple.first range

        variations =
            2 ^ String.length code - 1
    in
    inner ( 0, variations ) code


seatId : String -> Int
seatId s =
    let
        row =
            String.left 7 s

        col =
            String.right 3 s
    in
    codeToNum row * 8 + codeToNum col


seatIds : List Int
seatIds =
    input
        |> String.trim
        |> String.lines
        |> List.map (String.trim >> seatId)


part1 =
    seatIds
        |> List.maximum


part2 =
    let
        checkInc l =
            case l of
                f :: s :: rest ->
                    if s - f /= 1 then
                        Just ( f, s )
                            |> Debug.log "The seat is in between"

                    else
                        checkInc rest

                _ ->
                    Nothing
    in
    seatIds
        |> List.sort
        |> checkInc
