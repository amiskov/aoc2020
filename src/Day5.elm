module Day5 exposing (..)

import Day5.SeatId as SeatId exposing (SeatId)
import Day5Input exposing (input)


seatIds : List SeatId
seatIds =
    input
        |> String.trim
        |> String.lines
        |> List.map (String.trim >> SeatId.fromString)
        |> List.filterMap identity


part1 =
    seatIds
        |> List.map SeatId.toInt
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
        |> List.map SeatId.toInt
        |> List.sort
        |> findMissingId
