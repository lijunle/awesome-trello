module Login exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Model exposing (..)
import Trello
import WebAPI.Location


type Model
    = Login Name
    | Logout


type Msg
    = LoginMsg
    | LogoutMsg


init : Maybe Name -> ( Model, Cmd Msg )
init maybeName =
    case maybeName of
        Just name ->
            ( Login name, Cmd.none )

        Nothing ->
            ( Logout, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    {- TODO AJAX login/logout -}
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        Login name ->
            div []
                [ text "Hi, "
                , text name
                , text " "
                , a [ href logoutUrl ] [ text "Logout" ]
                ]

        Logout ->
            a [ href loginUrl ] [ text "Login" ]


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
            , ( "redirect_uri", location.href )
            ]

        authUrl =
            "https://trello.com/1/authorize"
    in
        Http.url authUrl query


logoutUrl : String
logoutUrl =
    let
        location =
            WebAPI.Location.location
    in
        location.origin ++ location.pathname
