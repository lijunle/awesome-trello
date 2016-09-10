module Board exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Model exposing (..)
import Request
import Task


type alias Model =
    { token : Token
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


init : Token -> Member -> ( Model, Cmd Msg )
init token member =
    let
        model =
            member |> toModel token

        firstBoard =
            List.head model.boards

        getCardCmd =
            firstBoard
                |> Maybe.map (getCard model.token)
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
                targetList =
                    cardList |> List.filter (\x -> List.isEmpty x.idMembers)

                newModel =
                    { model | cards = targetList }
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
                        |> List.filter (\x -> x.id == BoardId boardId)
                        |> List.head

                newModel =
                    { model | selectedBoard = board }

                cmd =
                    board
                        |> Maybe.map (getCard model.token)
                        |> Maybe.withDefault Cmd.none
            in
                ( newModel, cmd )

        SelectMember memberId ->
            let
                member =
                    model.members
                        |> List.filter (\x -> x.id == MemberId memberId)
                        |> List.head

                newModel =
                    { model | selectedMember = member }
            in
                ( newModel, Cmd.none )

        Submit ->
            let
                cmd =
                    case model.selectedMember of
                        Nothing ->
                            Cmd.none

                        Just selectedMember ->
                            setCardsMember
                                model.token
                                selectedMember
                                model.cards
            in
                ( model, cmd )


view : Model -> Html Msg
view model =
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
        (boards
            |> List.map
                (\x ->
                    option
                        [ value (toBoardIdString x.id) ]
                        [ text (toNameString x.name) ]
                )
        )


viewMemberSelector : List Member -> Html Msg
viewMemberSelector members =
    select [ onInput SelectMember ]
        (members
            |> List.map
                (\x ->
                    option
                        [ value (toMemberIdString x.id) ]
                        [ text (toNameString x.fullName) ]
                )
        )


viewCardList : List Card -> Html Msg
viewCardList cards =
    div []
        [ p []
            [ text "Affecting cards" ]
        , ul
            []
            (cards
                |> List.map
                    (\x ->
                        li []
                            [ text (toNameString x.name) ]
                    )
            )
        ]


viewSubmitButton : Html Msg
viewSubmitButton =
    button [ onClick Submit ]
        [ text "Submit" ]


toModel : Token -> Member -> Model
toModel token member =
    Model
        token
        member.boards
        []
        []
        (List.head member.boards)
        Nothing


getCard : Token -> Board -> Cmd Msg
getCard token board =
    Request.getBoardCards token board
        |> Task.perform FetchFail FetchCardSucceed


getBoardMembers : Token -> Board -> Cmd Msg
getBoardMembers token board =
    Request.getBoardMembers token board
        |> Task.perform FetchFail FetchMemberSucceed


setCardsMember : Token -> Member -> List Card -> Cmd Msg
setCardsMember token member cards =
    {- TODO run tasks simultanously -}
    cards
        |> List.map (Request.setCardMember token member)
        |> Task.sequence
        |> Task.perform FetchFail FetchCardSucceed
