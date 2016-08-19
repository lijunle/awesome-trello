module Request exposing (..)

import Http
import Json.Decode
import Model exposing (..)
import Model.Decode
import Task
import Trello


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


getBoardCards : String -> Board -> Task.Task Http.Error (List Card)
getBoardCards token board =
    let
        baseUrl =
            "boards/" ++ board.id ++ "/cards" |> toBaseUrl

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
        baseUrl =
            "boards/" ++ board.id ++ "/members" |> toBaseUrl

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
