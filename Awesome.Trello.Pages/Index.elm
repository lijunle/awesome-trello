module Main exposing (main)

import Board
import Html exposing (..)
import Html.App
import Http
import Login
import Model exposing (..)
import Model.Decode
import Task


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias PageModel =
    { login : Login.Model
    , boards : Board.Model
    }


type Model
    = Init
    | Error Http.Error
    | Page PageModel


init : ( Model, Cmd Msg )
init =
    ( Init, getConfig )


type Msg
    = FetchFail Http.Error
    | FetchSucceed Config
    | LoginMsg Login.Msg
    | BoardMsg Board.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchFail error ->
            ( Error error, Cmd.none )

        FetchSucceed config ->
            let
                loginModel =
                    Login.init config

                ( boardModel, boardMsg ) =
                    Board.init config

                pageModel =
                    { login = loginModel, boards = boardModel }
            in
                ( Page pageModel, Cmd.map BoardMsg boardMsg )

        LoginMsg msg ->
            case model of
                Page pageModel ->
                    let
                        ( loginModel, loginMsg ) =
                            Login.update msg pageModel.login

                        newModel =
                            { pageModel | login = loginModel }
                    in
                        ( Page newModel, Cmd.map LoginMsg loginMsg )

                _ ->
                    ( model, Cmd.none )

        BoardMsg msg ->
            case model of
                Page pageModel ->
                    let
                        ( boardModel, boardMsg ) =
                            Board.update msg pageModel.boards

                        newModel =
                            { pageModel | boards = boardModel }
                    in
                        ( Page newModel, Cmd.map BoardMsg boardMsg )

                _ ->
                    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        Init ->
            div [] [ text "Loading..." ]

        Error error ->
            div []
                [ text "Error happens: "
                , text (toString error)
                ]

        Page pageModel ->
            div []
                [ Html.App.map LoginMsg
                    (Login.view pageModel.login)
                , Html.App.map BoardMsg
                    (Board.view pageModel.boards)
                ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


getConfig : Cmd Msg
getConfig =
    let
        url =
            "/config.json"
    in
        Task.perform
            FetchFail
            FetchSucceed
            (Http.get Model.Decode.config url)
