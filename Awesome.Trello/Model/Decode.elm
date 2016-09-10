module Model.Decode exposing (..)

import Model exposing (..)
import Json.Decode exposing (..)


defaultTo : v -> Decoder v -> Decoder v
defaultTo value decoder =
    decoder |> maybe |> map (Maybe.withDefault value)


id : Decoder Id
id =
    map Id string


name : Decoder Name
name =
    map Name string


board : Decoder Board
board =
    object2
        Board
        ("id" := string)
        ("name" := string)


card : Decoder Card
card =
    object3
        Card
        ("id" := id)
        ("name" := name)
        ("idMembers" := list string)


webhook : Decoder Webhook
webhook =
    object5
        Webhook
        ("id" := id)
        ("active" := bool)
        ("idModel" := string)
        ("description" := string)
        ("callbackURL" := string)


member : Decoder Member
member =
    object3
        Member
        ("id" := id)
        ("fullName" := name)
        ("boards" := list board |> defaultTo [])
