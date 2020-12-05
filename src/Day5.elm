module Day5 exposing (..)

import Day5Input exposing (input)
import Html exposing (text)


main =
    text ""


type Tree a
    = Empty
    | Node a (Tree a)


exampleTree : Tree RowHalf
exampleTree =
    -- F B F B B F F
    Node F
        (Node B
            (Node F
                (Node B
                    (Node B
                        (Node F
                            (Node F Empty)
                        )
                    )
                )
            )
        )


type alias Range =
    ( Int, Int )


rowToNum : String -> Int
rowToNum s =
    parseRow s
        |> getRowNumber ( 0, 127 )


colToNum : String -> Int
colToNum s =
    parseCol s
        |> getColNumber ( 0, 7 )


getRowNumber : Range -> Tree RowHalf -> Int
getRowNumber range row =
    case row of
        Empty ->
            Tuple.first range

        Node half rest ->
            case half of
                F ->
                    let
                        ( min, max ) =
                            range
                    in
                    getRowNumber ( min, (max - min) // 2 + min ) rest

                B ->
                    let
                        ( min, max ) =
                            range
                    in
                    getRowNumber ( min + ((max - min) // 2) + 1, max ) rest


getColNumber : Range -> Tree ColHalf -> Int
getColNumber range row =
    case row of
        Empty ->
            Tuple.first range

        Node half rest ->
            case half of
                L ->
                    let
                        ( min, max ) =
                            range
                    in
                    getColNumber ( min, (max - min) // 2 + min ) rest

                R ->
                    let
                        ( min, max ) =
                            range
                    in
                    getColNumber ( min + ((max - min) // 2) + 1, max ) rest


type RowHalf
    = F
    | B


type ColHalf
    = L
    | R


parseRow : String -> Tree RowHalf
parseRow s =
    let
        parse rl =
            case String.uncons rl of
                Just ( 'F', rest ) ->
                    Node F (parse rest)

                Just ( 'B', rest ) ->
                    Node B (parse rest)

                _ ->
                    Empty
    in
    parse s


parseCol : String -> Tree ColHalf
parseCol s =
    let
        parse rl =
            case String.uncons rl of
                Just ( 'L', rest ) ->
                    Node L (parse rest)

                Just ( 'R', rest ) ->
                    Node R (parse rest)

                _ ->
                    Empty
    in
    parse s


type alias SeatId =
    Int


seatId : String -> SeatId
seatId s =
    let
        row =
            String.left 7 s

        col =
            String.right 3 s
    in
    rowToNum row * 8 + colToNum col


inputList : List String
inputList =
    input
        |> String.trim
        |> String.lines
        |> List.map (\s -> String.trim s)


sortedSeats =
    inputList
        |> List.map seatId
        |> List.sort


part1 =
    inputList
        |> List.map seatId
        |> List.maximum
