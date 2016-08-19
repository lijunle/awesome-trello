module Request exposing (..)

import Http
import Json.Decode
import Model exposing (..)
import Model.Decode
import Task
import Trello


getBoardCards : String -> Board -> Task.Task Http.Error (List Card)
getBoardCards token board =
    let
        baseUrl =
            "https://api.trello.com/1/boards/" ++ board.id ++ "/cards"

        query =
            [ ( "key", Trello.key )
            , ( "token", token )
            , ( "filter", "open" )
            , ( "fields", "name,idMembers" )
            ]

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
            "https://api.trello.com/1/boards/" ++ board.id ++ "/members"

        query =
            [ ( "key", Trello.key )
            , ( "token", token )
            , ( "filter", "all" )
            , ( "fields", "fullName" )
            ]

        url =
            Http.url baseUrl query

        memberList =
            Json.Decode.list Model.Decode.member
    in
        Http.get memberList url
