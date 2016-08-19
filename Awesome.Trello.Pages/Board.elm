module Board exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode
import Model exposing (..)
import Request
import Task


type alias Model =
    { token : String
    , boards : List Board
    , members : List Member
    , cards : List Card
    , selectedBoard : Maybe Board
    , selectedMember : Maybe Member
    }


type Msg
    = FetchFail Http.Error
    | FetchCardSucceed (List Card)
    | FetchMemberSucceed (List Member)
    | SelectBoard String
    | SelectMember String
    | Submit
    | SubmitSucceed Bool


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

        getBoardMembersCmd =
            firstBoard
                |> Maybe.map (getBoardMembers model.token)
                |> Maybe.withDefault Cmd.none

        cmd =
            Cmd.batch [ getCardCmd, getBoardMembersCmd ]
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

        SelectBoard boardId ->
            let
                board =
                    model.boards
                        |> List.filter (\x -> x.id == boardId)
                        |> List.head

                newModel =
                    { model | selectedBoard = board }

                cmd =
                    board
                        |> Maybe.map getCard
                        |> Maybe.withDefault Cmd.none
            in
                ( newModel, cmd )

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

        Submit ->
            let
                cmd =
                    Maybe.map2
                        assignBoard
                        model.selectedBoard
                        model.selectedMember
                        |> Maybe.withDefault Cmd.none
            in
                ( model, cmd )

        SubmitSucceed result ->
            let
                cmd =
                    model.selectedBoard
                        |> Maybe.map getCard
                        |> Maybe.withDefault Cmd.none
            in
                ( model, cmd )


view : Model -> Html Msg
view model =
    if List.isEmpty model.boards then
        div [] []
    else
        div []
            [ div []
                [ viewBoardSelector model.boards
                , viewMemberSelector model.members
                , viewSubmitButton
                ]
            , viewCardList model.cards
            ]


viewBoardSelector : List Board -> Html Msg
viewBoardSelector boards =
    select [ onInput SelectBoard ]
        (boards |> List.map (\x -> option [ value x.id ] [ text x.name ]))


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


viewSubmitButton : Html Msg
viewSubmitButton =
    button [ onClick Submit ]
        [ text "Submit" ]


toModel : Config -> Model
toModel config =
    Model
        (config.token |> Maybe.withDefault "")
        config.boards
        []
        []
        (List.head config.boards)
        Nothing


getCard : Board -> Cmd Msg
getCard board =
    let
        url =
            "/card.json?board=" ++ board.name
    in
        Task.perform
            FetchFail
            FetchCardSucceed
            (Http.get (Json.Decode.list Json.Decode.string) url)


getBoardMembers : String -> Board -> Cmd Msg
getBoardMembers token board =
    Request.getBoardMembers token board
        |> Task.perform FetchFail FetchMemberSucceed


assignBoard : Board -> Member -> Cmd Msg
assignBoard board member =
    let
        url =
            "/board/assign?board=" ++ board.name ++ "&member=" ++ member.id
    in
        Task.perform
            FetchFail
            SubmitSucceed
            (Http.post Json.Decode.bool url Http.empty)
