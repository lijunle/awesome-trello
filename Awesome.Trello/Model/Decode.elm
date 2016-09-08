module Model.Decode exposing (..)

import Model exposing (..)
import Json.Decode
import Json.Decode exposing ((:=))


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


boards : Json.Decode.Decoder (List Board)
boards =
    Json.Decode.at [ "boards" ] (Json.Decode.list board)


card : Json.Decode.Decoder Card
card =
    Json.Decode.object3 Card id name idMembers


webhook : Json.Decode.Decoder Webhook
webhook =
    Json.Decode.object5
        Webhook
        ("id" := Json.Decode.string)
        ("active" := Json.Decode.bool)
        ("idModel" := Json.Decode.string)
        ("description" := Json.Decode.string)
        ("callbackURL" := Json.Decode.string)


member : Json.Decode.Decoder Member
member =
    let
        boardsWithDefault =
            Json.Decode.maybe boards
                |> Json.Decode.map (Maybe.withDefault [])
    in
        Json.Decode.object3 Member id fullName boardsWithDefault
