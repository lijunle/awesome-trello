module Request exposing (..)

import Http
import Json.Decode
import Model exposing (..)
import Model.Decode
import Task


key : String
key =
    ""


getBoardMembers : String -> Board -> Task.Task Http.Error (List Member)
getBoardMembers token board =
    let
        baseUrl =
            "https://api.trello.com/1/boards/" ++ board.id ++ "/members"

        query =
            [ ( "key", key )
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
