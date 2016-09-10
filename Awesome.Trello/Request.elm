module Request exposing (..)

import Http
import Json.Decode
import Json.Encode
import Model exposing (..)
import Model.Decode
import Task
import Trello


put : String -> Json.Decode.Decoder a -> Json.Encode.Value -> Task.Task Http.Error a
put url decoder payload =
    let
        body =
            payload
                |> Json.Encode.encode 0
                |> Http.string

        request =
            { verb = "PUT"
            , headers = [ ( "Content-Type", "application/json" ) ]
            , url = url
            , body = body
            }
    in
        Http.send Http.defaultSettings request
            |> Http.fromJson decoder


patchToken : String -> List ( String, String ) -> List ( String, String )
patchToken token query =
    let
        common =
            [ ( "key", Trello.key )
            , ( "token", token )
            ]
    in
        List.concat [ common, query ]


toBaseUrl : String -> String
toBaseUrl endPoint =
    "https://api.trello.com/1/" ++ endPoint


getMemberMe : String -> Task.Task Http.Error Member
getMemberMe token =
    let
        baseUrl =
            "members/me" |> toBaseUrl

        query =
            [ ( "fields", "fullName" )
            , ( "boards", "open" )
            ]
                |> patchToken token

        url =
            Http.url baseUrl query

        member =
            Model.Decode.member
    in
        Http.get member url


getBoardCards : String -> Board -> Task.Task Http.Error (List Card)
getBoardCards token board =
    let
        boardId =
            board.id |> toBoardIdString

        baseUrl =
            "boards/" ++ boardId ++ "/cards" |> toBaseUrl

        query =
            [ ( "filter", "open" )
            , ( "fields", "name,idMembers" )
            ]
                |> patchToken token

        url =
            Http.url baseUrl query

        cardList =
            Json.Decode.list Model.Decode.card
    in
        Http.get cardList url


getBoardMembers : String -> Board -> Task.Task Http.Error (List Member)
getBoardMembers token board =
    let
        boardId =
            board.id |> toBoardIdString

        baseUrl =
            "boards/" ++ boardId ++ "/members" |> toBaseUrl

        query =
            [ ( "filter", "all" )
            , ( "fields", "fullName" )
            ]
                |> patchToken token

        url =
            Http.url baseUrl query

        memberList =
            Json.Decode.list Model.Decode.member
    in
        Http.get memberList url


setCardMember : String -> Member -> Card -> Task.Task Http.Error Card
setCardMember token member card =
    let
        cardId =
            card.id |> toIdString

        baseUrl =
            "cards/" ++ cardId ++ "/idMembers" |> toBaseUrl

        query =
            [] |> patchToken token

        url =
            Http.url baseUrl query

        cardDecoder =
            Model.Decode.card

        body =
            [ ( "value", member.id |> toIdString |> Json.Encode.string ) ]
                |> Json.Encode.object
    in
        put url cardDecoder body


getWebhooks : String -> Task.Task Http.Error (List Webhook)
getWebhooks token =
    let
        baseUrl =
            "/tokens/" ++ token ++ "/webhooks" |> toBaseUrl

        query =
            [] |> patchToken token

        url =
            Http.url baseUrl query

        webhooksDecoder =
            Model.Decode.webhook |> Json.Decode.list
    in
        Http.get webhooksDecoder url
