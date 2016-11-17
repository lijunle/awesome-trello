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
    map2
        Board
        (field "id" boardId)
        (field "name" name)


card : Decoder Card
card =
    map3
        Card
        (field "id" cardId)
        (field "name" name)
        (field "idMembers" (list memberId))


webhook : Decoder Webhook
webhook =
    map5
        Webhook
        (field "id" webhookId)
        (field "active" bool)
        (field "idModel" boardId)
        (field "description" string)
        (field "callbackURL" string)


member : Decoder Member
member =
    map3
        Member
        (field "id" memberId)
        (field "fullName" name)
        (field "boards" (list board) |> defaultTo [])
