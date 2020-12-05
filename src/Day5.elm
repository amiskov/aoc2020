module Day5 exposing (..)

import Day5Input exposing (input)


getNumber : ( Int, Int ) -> String -> Int
getNumber ( min, max ) row =
    let
        getLeft rest =
            getNumber ( min, (max - min) // 2 + min ) rest

        getRight rest =
            getNumber ( min + ((max - min) // 2) + 1, max ) rest
    in
    case String.uncons row of
        Just ( 'F', rest ) ->
            getLeft rest

        Just ( 'L', rest ) ->
            getLeft rest

        Just ( 'B', rest ) ->
            getRight rest

        Just ( 'R', rest ) ->
            getRight rest

        _ ->
            min


seatId : String -> Int
seatId s =
    let
        row =
            String.left 7 s

        col =
            String.right 3 s
    in
    getNumber ( 0, 127 ) row * 8 + getNumber ( 0, 7 ) col


seatIds : List Int
seatIds =
    input
        |> String.trim
        |> String.lines
        |> List.map (\s -> String.trim s)
        |> List.map seatId


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
