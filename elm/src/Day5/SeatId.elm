module Day5.SeatId exposing (SeatId, fromString, toInt)

import Day5.Col as Col exposing (Col)
import Day5.Row as Row exposing (Row)


type SeatId
    = SeatId Int


fromString : String -> Maybe SeatId
fromString code =
    let
        row =
            code
                |> String.left 7
                |> Row.fromString

        col =
            code
                |> String.right 3
                |> Col.fromString
    in
    case ( row, col ) of
        ( Just r, Just c ) ->
            ((Row.toDecimal r * 8) + Col.toDecimal c) |> SeatId |> Just

        _ ->
            Nothing


toInt : SeatId -> Int
toInt (SeatId id) =
    id
