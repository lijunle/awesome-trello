module Login exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Model exposing (..)
import Trello
import WebAPI.Location


type Model
    = Login
    | Logout Name


type Msg
    = LoginMsg
    | LogoutMsg


init : Maybe Name -> Model
init maybeName =
    case maybeName of
        Nothing ->
            Login

        Just name ->
            Logout name


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    {- TODO AJAX login/logout -}
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        Login ->
            a [ href loginUrl ] [ text "Login" ]

        Logout name ->
            div []
                [ text "Hi, "
                , text name
                , text " "
                , a [ href "/logout" ] [ text "Logout" ]
                ]


loginUrl : String
loginUrl =
    let
        location =
            WebAPI.Location.location

        query =
            [ ( "expiration", "never" )
            , ( "response_type", "token" )
            , ( "callback_method", "fragment" )
            , ( "scope", "read,write,account" )
            , ( "name", Trello.appName )
            , ( "key", Trello.key )
            , ( "redirect_uri", location.origin )
            ]

        authUrl =
            "https://trello.com/1/authorize"
    in
        Http.url authUrl query
