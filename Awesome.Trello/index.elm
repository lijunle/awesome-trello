module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Login


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { login : Login.Model }


init : ( Model, Cmd Msg )
init =
    let
        ( loginModel, loginMsg ) =
            Login.init
    in
        ( Model loginModel, Cmd.map LoginMsg loginMsg )


type Msg
    = Init
    | LoginMsg Login.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Init ->
            ( model, Cmd.none )

        LoginMsg msg ->
            let
                ( loginModel, loginMsg ) =
                    Login.update msg model.login
            in
                ( Model loginModel, Cmd.map LoginMsg loginMsg )


view : Model -> Html Msg
view model =
    div []
        [ App.map LoginMsg (Login.view model.login)
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
