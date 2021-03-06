module Day5Simple exposing (..)

import Binary
import Day5.Input exposing (input)


toSeatId : String -> Int
toSeatId code =
    -- We don't have to do `row * 8 + col` since `row * 8` is the same as bit-shift by 3:
    -- FBFBBFF    → 0101100    → 44
    --               0101100000 → 352 == 44 * 8
    --        RLR →        101 → 5
    -- FBFBBFFRLR → 0101100101 → 357 == 44 * 8 + 5
    code
        |> String.replace "F" "0"
        |> String.replace "B" "1"
        |> String.replace "L" "0"
        |> String.replace "R" "1"
        |> Binary.fromString 1
        |> Binary.toDecimal


seatIds : List Int
seatIds =
    input
        |> String.trim
        |> String.lines
        |> List.map (String.trim >> toSeatId)


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
