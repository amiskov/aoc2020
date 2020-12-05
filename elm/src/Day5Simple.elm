module Day5Simple exposing (..)

import Day5.Input exposing (input)


findIdxByCode : String -> Int
findIdxByCode code =
    let
        maxIdx =
            2 ^ String.length code - 1

        findIdx : ( Int, Int ) -> String -> Int
        findIdx range row =
            case String.uncons row of
                Just ( 'F', rest ) ->
                    toLowerHalf range rest

                Just ( 'L', rest ) ->
                    toLowerHalf range rest

                Just ( 'B', rest ) ->
                    toUpperHalf range rest

                Just ( 'R', rest ) ->
                    toUpperHalf range rest

                _ ->
                    Tuple.first range

        toLowerHalf ( lowest, highest ) rest =
            let
                newHighest =
                    (highest - lowest) // 2 + lowest
            in
            findIdx ( lowest, newHighest ) rest

        toUpperHalf ( lowest, highest ) rest =
            let
                newLowest =
                    lowest + ((highest - lowest) // 2) + 1
            in
            findIdx ( newLowest, highest ) rest
    in
    findIdx ( 0, maxIdx ) code


seatId : String -> Int
seatId s =
    let
        row =
            String.left 7 s

        col =
            String.right 3 s
    in
    findIdxByCode row * 8 + findIdxByCode col


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
        findMissingId ids =
            case ids of
                first :: second :: rest ->
                    if second - first /= 1 then
                        Just (first + 1)

                    else
                        findMissingId rest

                _ ->
                    Nothing
    in
    seatIds
        |> List.sort
        |> findMissingId
