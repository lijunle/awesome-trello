module Request exposing (..)

import Http
import Json.Decode
import Json.Encode
import Model exposing (..)
import Model.Decode
import Trello


buildUrl : String -> List ( String, String ) -> String
buildUrl baseUrl query =
    case query of
        [] ->
            baseUrl

        _ ->
            let
                queryPairs =
                    query |> List.map (\( key, value ) -> Http.encodeUri key ++ "=" ++ Http.encodeUri value)

                queryString =
                    queryPairs |> String.join "&"
            in
                baseUrl ++ "?" ++ queryString


put : String -> Http.Body -> Http.Expect a -> Http.Request a
put url body expect =
    Http.request
        { method = "PUT"
        , headers = []
        , url = url
        , body = body
        , expect = expect
        , timeout = Nothing
        , withCredentials = False
        }


patchToken : Token -> List ( String, String ) -> List ( String, String )
patchToken token query =
    let
        common =
            [ ( "key", Trello.key )
            , ( "token", token |> toTokenString )
            ]
    in
        List.concat [ common, query ]


toBaseUrl : String -> String
toBaseUrl endPoint =
    "https://api.trello.com/1/" ++ endPoint


getMemberMe : Token -> Http.Request Member
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
            buildUrl baseUrl query

        member =
            Model.Decode.member
    in
        Http.get url member


getBoardCards : Token -> Board -> Http.Request (List Card)
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
            buildUrl baseUrl query

        cardList =
            Json.Decode.list Model.Decode.card
    in
        Http.get url cardList


getBoardMembers : Token -> Board -> Http.Request (List Member)
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
            buildUrl baseUrl query

        memberList =
            Json.Decode.list Model.Decode.member
    in
        Http.get url memberList


setCardMember : Token -> Member -> Card -> Http.Request Card
setCardMember token member card =
    let
        cardId =
            card.id |> toCardIdString

        baseUrl =
            "cards/" ++ cardId ++ "/idMembers" |> toBaseUrl

        query =
            [] |> patchToken token

        url =
            buildUrl baseUrl query

        expectCard =
            Http.expectJson Model.Decode.card

        body =
            [ ( "value", member.id |> toMemberIdString |> Json.Encode.string ) ]
                |> Json.Encode.object
                |> Http.jsonBody
    in
        put url body expectCard


getWebhooks : Token -> Http.Request (List Webhook)
getWebhooks token =
    let
        tokenString =
            token |> toTokenString

        baseUrl =
            "/tokens/" ++ tokenString ++ "/webhooks" |> toBaseUrl

        query =
            [] |> patchToken token

        url =
            buildUrl baseUrl query

        webhooksDecoder =
            Model.Decode.webhook |> Json.Decode.list
    in
        Http.get url webhooksDecoder
