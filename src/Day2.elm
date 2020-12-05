module Day2 exposing (..)

import Day2Input exposing (input)
import Html exposing (text)
import Parser exposing ((|.), (|=), Parser, chompIf, chompWhile, float, int, run, spaces, succeed, symbol)


testInput =
    """
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
"""


passwordEntry : Parser PasswordEntry
passwordEntry =
    succeed PasswordEntry
        |= int
        |. symbol "-"
        |= int
        |. spaces
        |= chompIf Char.isAlphaNum
        |. symbol ":"
        |. spaces



--|= chompWhile (\c -> Char.isAlpha c)


type alias PasswordEntry =
    { first : Int
    , second : Int
    , letter : Char

    --, password : String
    }


main =
    text ""
