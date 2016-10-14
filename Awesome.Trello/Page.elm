module Page exposing (Model, Msg, init, update, urlUpdate, view, subscriptions)

import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Model exposing (..)
import Page.Index
import Router


type Data a
    = Loading
    | Loaded a


type Model
    = Index Page.Index.Model
    | Error String
    | Boards
    | Board (Data Board)


type Msg
    = IndexPageMsg Page.Index.Msg


urlUpdate : Result String Router.Path -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    case result of
        Err error ->
            ( Error (toString error), Cmd.none )

        Ok (Router.Index) ->
            init result

        Ok (Router.Error) ->
            init result

        Ok (Router.Boards) ->
            ( Boards, Cmd.none )

        Ok (Router.Board boardId) ->
            {- TODO get board command -}
            ( Board Loading, Cmd.none )


init : Result String Router.Path -> ( Model, Cmd Msg )
init result =
    let
        ( indexModel, indexMsg ) =
            Page.Index.init
    in
        ( Index indexModel, Cmd.map IndexPageMsg indexMsg )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( IndexPageMsg msg, Index indexPage ) ->
            let
                ( newPage, newMsg, newError ) =
                    Page.Index.update msg indexPage
            in
                ( Index newPage |> checkError newError
                , Cmd.map IndexPageMsg newMsg
                )

        _ ->
            {- We only care about the matched cases, ignore others. -}
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        Index indexPage ->
            div [] [ viewNavigation, indexPage |> Page.Index.view |> Html.App.map IndexPageMsg ]

        Error error ->
            div [] [ viewNavigation, text "Error", text error ]

        Boards ->
            div [] [ viewNavigation, text "Boards" ]

        Board board ->
            div [] [ viewNavigation, text (toString board) ]


viewNavigation : Html Msg
viewNavigation =
    nav []
        [ a [ href (Router.toHash Router.Index) ] [ text "Index" ]
        , a [ href (Router.toHash Router.Boards) ] [ text "Boards" ]
        ]


checkError : Maybe String -> Model -> Model
checkError error model =
    case error of
        Just error ->
            Error error

        Nothing ->
            model


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
