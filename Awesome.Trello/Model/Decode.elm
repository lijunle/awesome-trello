module Model.Decode exposing (..)

import Model exposing (..)
import Json.Decode exposing (..)


defaultTo : v -> Decoder v -> Decoder v
defaultTo value decoder =
    decoder |> maybe |> map (Maybe.withDefault value)


boardId : Decoder BoardId
boardId =
    map BoardId string


cardId : Decoder CardId
cardId =
    map CardId string


memberId : Decoder MemberId
memberId =
    map MemberId string


webhookId : Decoder WebhookId
webhookId =
    map WebhookId string


name : Decoder Name
name =
    map Name string


token : Decoder Token
token =
    map Token string


board : Decoder Board
board =
    object2
        Board
        ("id" := boardId)
        ("name" := name)


card : Decoder Card
card =
    object3
        Card
        ("id" := cardId)
        ("name" := name)
        ("idMembers" := list memberId)


webhook : Decoder Webhook
webhook =
    object5
        Webhook
        ("id" := webhookId)
        ("active" := bool)
        ("idModel" := boardId)
        ("description" := string)
        ("callbackURL" := string)


member : Decoder Member
member =
    object3
        Member
        ("id" := memberId)
        ("fullName" := name)
        ("boards" := list board |> defaultTo [])
