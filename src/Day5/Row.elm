module Day5.Row exposing (Row, fromString, toDecimal)

import Binary


type RowHalf
    = F
    | B


type Row
    = Row (List RowHalf)


fromString : String -> Maybe Row
fromString s =
    let
        parts : List RowHalf
        parts =
            s
                |> String.toList
                |> List.concatMap
                    (\c ->
                        case c of
                            'F' ->
                                [ F ]

                            'B' ->
                                [ B ]

                            _ ->
                                []
                    )
    in
    if List.length parts == 7 then
        Just <| Row parts

    else
        Nothing


toDecimal : Row -> Int
toDecimal (Row row) =
    row
        |> List.map
            (\el ->
                case el of
                    F ->
                        0

                    B ->
                        1
            )
        |> Binary.fromIntegers
        |> Binary.toDecimal
