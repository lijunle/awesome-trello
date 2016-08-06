module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Http
import Json.Decode as Json
import Json.Decode exposing ((:=))
import Task


main : Program Never
main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Name =
    String


type alias Url =
    String


type alias Config =
    { name : Maybe Name
    }


type Model
    = Init
    | Login
    | Logout Name


init : ( Model, Cmd Msg )
init =
    ( Init, getConfig )


type Msg
    = GetConfig
    | FetchSucceed Config
    | FetchFail Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetConfig ->
            ( model, getConfig )

        FetchSucceed config ->
            ( config |> toModel, Cmd.none )

        FetchFail error ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        Init ->
            text ""

        Login ->
            a [ href "/login" ] [ text "Login" ]

        Logout name ->
            div []
                [ text "Hi, "
                , text name
                , a [ href "/logout" ] [ text "Logout" ]
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
        Task.perform FetchFail FetchSucceed (Http.get decodeUrl url)


toModel : Config -> Model
toModel config =
    case config.name of
        Just name ->
            Logout name

        Nothing ->
            Login


decodeUrl : Json.Decoder Config
decodeUrl =
    Json.object1
        Config
        ("Name" := (Json.maybe Json.string))
