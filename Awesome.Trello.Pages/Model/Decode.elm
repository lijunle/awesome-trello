module Model.Decode exposing (..)

import Model exposing (..)
import Json.Decode


board : Json.Decode.Decoder Board
board =
    Json.Decode.object2
        Board
        (Json.Decode.at [ "id" ] Json.Decode.string)
        (Json.Decode.at [ "name" ] Json.Decode.string)


member : Json.Decode.Decoder Member
member =
    Json.Decode.object2
        Member
        (Json.Decode.at [ "id" ] Json.Decode.string)
        (Json.Decode.at [ "fullName" ] Json.Decode.string)


config : Json.Decode.Decoder Config
config =
    Json.Decode.object3
        Config
        (Json.Decode.at [ "Token" ] (Json.Decode.maybe Json.Decode.string))
        (Json.Decode.at [ "Name" ] (Json.Decode.maybe Json.Decode.string))
        (Json.Decode.at [ "Boards" ] (Json.Decode.list board))
