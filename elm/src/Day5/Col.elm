module Day5.Col exposing (Col, fromString, toDecimal)

import Binary


type ColHalf
    = L
    | R


type Col
    = Col (List ColHalf)


fromString : String -> Maybe Col
fromString s =
    let
        parts : List ColHalf
        parts =
            s
                |> String.toList
                |> List.concatMap
                    (\c ->
                        case c of
                            'L' ->
                                [ L ]

                            'R' ->
                                [ R ]

                            _ ->
                                []
                    )
    in
    if List.length parts == 3 then
        Just <| Col parts

    else
        Nothing


toDecimal : Col -> Int
toDecimal (Col row) =
    row
        |> List.map
            (\el ->
                case el of
                    L ->
                        0

                    R ->
                        1
            )
        |> Binary.fromIntegers
        |> Binary.toDecimal
