module Day5 exposing (..)

import Day5.Input exposing (input)
import Day5.SeatId as SeatId exposing (SeatId)



{- The goal for this day is practice with opaque types and have a get familiar with the `Binary` package.
   There are simpler solutions for this puzzle in the commit history.
-}


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
