module Login exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)
import Request
import Task
import Trello
import WebAPI.Location


type alias Urls =
    { login : Url
    , logout : Url
    }


type alias Model =
    { name : Maybe Name
    , urls : Urls
    }


type Msg
    = GetUrls Urls


init : Maybe Name -> ( Model, Cmd Msg )
init maybeName =
    let
        urls =
            { login = Url "", logout = Url "" }

        model =
            { name = maybeName, urls = urls }

        cmd =
            WebAPI.Location.location
                |> Task.map getUrls
                |> Task.perform GetUrls
    in
        ( model, cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetUrls urls ->
            ( { model | urls = urls }, Cmd.none )


view : Model -> Html Msg
view model =
    case model.name of
        Just name ->
            div []
                [ text "Hi, "
                , text (toNameString name)
                , text " "
                , a [ href (toUrlString model.urls.logout) ] [ text "Logout" ]
                ]

        Nothing ->
            a [ href (toUrlString model.urls.login) ] [ text "Login" ]


getUrls : WebAPI.Location.Location -> Urls
getUrls location =
    let
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

        loginUrl =
            Request.buildUrl authUrl query

        logoutUrl =
            location.origin ++ location.pathname
    in
        { login = Url loginUrl, logout = Url logoutUrl }
