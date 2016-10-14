module Page.Index exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Model exposing (..)
import Task
import Trello
import WebAPI.Location


type alias Model =
    { loginUrl : Url
    }


type Msg
    = Error String
    | GotLoginUrl Url


init : ( Model, Cmd Msg )
init =
    let
        model =
            { loginUrl = Url "#"
            }

        cmd =
            WebAPI.Location.location
                |> Task.map getUrls
                |> Task.perform Error GotLoginUrl
    in
        ( model, cmd )


update : Msg -> Model -> ( Model, Cmd Msg, Maybe String )
update msg model =
    case msg of
        Error error ->
            ( model, Cmd.none, Just error )

        GotLoginUrl loginUrl ->
            ( { model | loginUrl = loginUrl }, Cmd.none, Nothing )


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Awesome Trello" ]
        , a [ href (toUrlString model.loginUrl) ] [ text "Login" ]
        ]


getUrls : WebAPI.Location.Location -> Url
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
            Http.url authUrl query
    in
        Url loginUrl
