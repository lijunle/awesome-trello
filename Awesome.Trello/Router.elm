module Router exposing (Path(..), toHash, parseHash)

import Navigation
import UrlParser exposing ((</>))
import String


type Path
    = Index
    | Error
    | Boards
    | Board Int


toHash : Path -> String
toHash path =
    case path of
        Index ->
            "#"

        Error ->
            "#error"

        Boards ->
            "#boards"

        Board boardId ->
            "#board/" ++ (toString boardId)


parseHash : Navigation.Location -> Result String Path
parseHash location =
    location.hash
        |> String.dropLeft 1
        |> UrlParser.parse identity pageParser


pageParser : UrlParser.Parser (Path -> a) a
pageParser =
    UrlParser.oneOf
        [ UrlParser.format Index (UrlParser.s "")
        , UrlParser.format Error (UrlParser.s "error")
        , UrlParser.format Boards (UrlParser.s "boards")
        , UrlParser.format Board (UrlParser.s "board" </> UrlParser.int)
        ]
