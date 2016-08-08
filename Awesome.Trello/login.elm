module Login exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)


type Model
    = Login
    | Logout Name


type Msg
    = LoginMsg
    | LogoutMsg


init : Config -> Model
init config =
    config |> toModel


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    {- TODO AJAX login/logout -}
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        Login ->
            a [ href "/login" ] [ text "Login" ]

        Logout name ->
            div []
                [ text "Hi, "
                , text name
                , text " "
                , a [ href "/logout" ] [ text "Logout" ]
                ]


toModel : Config -> Model
toModel config =
    case config.name of
        Just name ->
            Logout name

        Nothing ->
            Login
