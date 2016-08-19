module Model.Decode exposing (..)

import Model exposing (..)
import Json.Decode


id : Json.Decode.Decoder String
id =
    Json.Decode.at [ "id" ] Json.Decode.string


name : Json.Decode.Decoder String
name =
    Json.Decode.at [ "name" ] Json.Decode.string


fullName : Json.Decode.Decoder String
fullName =
    Json.Decode.at [ "fullName" ] Json.Decode.string


idMembers : Json.Decode.Decoder (List String)
idMembers =
    Json.Decode.at [ "idMembers" ] (Json.Decode.list Json.Decode.string)


board : Json.Decode.Decoder Board
board =
    Json.Decode.object2 Board id name


card : Json.Decode.Decoder Card
card =
    Json.Decode.object3 Card id name idMembers


member : Json.Decode.Decoder Member
member =
    Json.Decode.object2 Member id fullName


config : Json.Decode.Decoder Config
config =
    Json.Decode.object3
        Config
        (Json.Decode.at [ "Token" ] (Json.Decode.maybe Json.Decode.string))
        (Json.Decode.at [ "Name" ] (Json.Decode.maybe Json.Decode.string))
        (Json.Decode.at [ "Boards" ] (Json.Decode.list board))
