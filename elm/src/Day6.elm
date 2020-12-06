module Day6 exposing (..)

import Day6Input exposing (input, inputSample)
import List.Extra as LE


parseInput : String -> List String
parseInput =
    String.trim >> String.split "\n\n"


part1 =
    parseInput input
        |> List.map (String.replace "\n" "" >> String.split "" >> LE.unique >> List.length)
        |> List.sum


part2 =
    parseInput input
        |> List.map (String.split "\n" >> countAllEqual)
        |> List.sum


{-| Counts answers which are equal for all members in a group:

        countAllEqual ["abc"] == 3
        countAllEqual ["ab", "cd"] == 0
        countAllEqual ["ab", "ac"] == 1
        countAllEqual ["a", "a", "a", "a"] == 1

-}
countAllEqual : List String -> Int
countAllEqual membersAnswers =
    let
        membersQty =
            List.length membersAnswers

        isAnswerEqualForAll : ( String, List String ) -> Bool
        isAnswerEqualForAll ( _, others ) =
            List.length others + 1 == membersQty
    in
    membersAnswers
        |> List.concatMap (String.split "")
        -- ["a","b","a","c"]
        |> LE.gatherEquals
        -- [("a",["a"]),("b",[]),("c",[])]
        |> List.filter isAnswerEqualForAll
        |> List.length
