module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Login
import Board


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { login : Login.Model
    , boards : Board.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        ( loginModel, loginMsg ) =
            Login.init

        ( boardModel, boardMsg ) =
            Board.init

        model =
            Model loginModel boardModel

        loginCmd =
            Cmd.map LoginMsg loginMsg

        boardCmd =
            Cmd.map BoardMsg boardMsg

        cmd =
            Cmd.batch [ loginCmd, boardCmd ]
    in
        ( model, cmd )


type Msg
    = Init
    | LoginMsg Login.Msg
    | BoardMsg Board.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Init ->
            ( model, Cmd.none )

        LoginMsg msg ->
            let
                ( loginModel, loginMsg ) =
                    Login.update msg model.login

                newModel =
                    { model | login = loginModel }
            in
                ( newModel, Cmd.map LoginMsg loginMsg )

        BoardMsg msg ->
            let
                ( boardModel, boardMsg ) =
                    Board.update msg model.boards

                newModel =
                    { model | boards = boardModel }
            in
                ( newModel, Cmd.map BoardMsg boardMsg )


view : Model -> Html Msg
view model =
    div []
        [ App.map LoginMsg
            (Login.view model.login)
        , App.map BoardMsg
            (Board.view model.boards)
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
