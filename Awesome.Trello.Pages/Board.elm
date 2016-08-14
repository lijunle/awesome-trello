module Board exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode
import Model exposing (..)
import Task


type alias Model =
    { boards : List Board
    , members : List Member
    , cards : List Card
    , selectedBoard : Maybe Board
    , selectedMember : Maybe Member
    }


type Msg
    = FetchFail Http.Error
    | FetchCardSucceed (List Card)
    | FetchMemberSucceed (List Member)
    | SelectBoard Board
    | SelectMember String


init : Config -> ( Model, Cmd Msg )
init config =
    let
        model =
            config |> toModel

        firstBoard =
            List.head model.boards

        getCardCmd =
            firstBoard
                |> Maybe.map getCard
                |> Maybe.withDefault Cmd.none

        getMembersCmd =
            firstBoard
                |> Maybe.map getMembers
                |> Maybe.withDefault Cmd.none

        cmd =
            Cmd.batch [ getCardCmd, getMembersCmd ]
    in
        ( model, cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchFail error ->
            {- TODO should do something on error? -}
            ( model, Cmd.none )

        FetchCardSucceed cardList ->
            let
                newModel =
                    { model | cards = cardList }
            in
                ( newModel, Cmd.none )

        FetchMemberSucceed memberList ->
            let
                member =
                    List.head memberList

                newModel =
                    { model | members = memberList, selectedMember = member }
            in
                ( newModel, Cmd.none )

        SelectBoard board ->
            let
                newModel =
                    { model | selectedBoard = Just board }
            in
                ( newModel, getCard board )

        SelectMember memberId ->
            let
                member =
                    model.members
                        |> List.filter (\x -> x.id == memberId)
                        |> List.head

                newModel =
                    { model | selectedMember = member }
            in
                ( newModel, Cmd.none )


view : Model -> Html Msg
view model =
    if List.isEmpty model.boards then
        div [] []
    else
        div []
            [ div []
                [ (viewBoardSelector model.boards)
                , (viewMemberSelector model.members)
                ]
            , viewCardList model.cards
            ]


viewBoardSelector : List Board -> Html Msg
viewBoardSelector boards =
    select [ onInput SelectBoard ]
        (boards |> List.map (\x -> option [] [ text x ]))


viewMemberSelector : List Member -> Html Msg
viewMemberSelector members =
    select [ onInput SelectMember ]
        (members |> List.map (\x -> option [ value x.id ] [ text x.fullName ]))


viewCardList : List Card -> Html Msg
viewCardList cards =
    div []
        [ p []
            [ text "Affecting cards" ]
        , ul
            []
            (cards |> List.map (\x -> li [] [ text x ]))
        ]


toModel : Config -> Model
toModel config =
    Model
        config.boards
        []
        []
        (List.head config.boards)
        Nothing


getCard : Board -> Cmd Msg
getCard board =
    let
        url =
            "/card.json?board=" ++ board
    in
        Task.perform
            FetchFail
            FetchCardSucceed
            (Http.get (Json.Decode.list Json.Decode.string) url)


getMembers : Board -> Cmd Msg
getMembers board =
    let
        url =
            "/board-members.json?board=" ++ board
    in
        Task.perform
            FetchFail
            FetchMemberSucceed
            (Http.get decodeMemberList url)


decodeMemberList : Json.Decode.Decoder (List Member)
decodeMemberList =
    Json.Decode.object2
        Member
        (Json.Decode.at [ "id" ] Json.Decode.string)
        (Json.Decode.at [ "fullName" ] Json.Decode.string)
        |> Json.Decode.list
