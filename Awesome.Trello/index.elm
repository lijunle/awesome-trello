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
    , loginUrl : Url
    , logoutUrl : Url
    }


type Model
    = Login Url
    | Logout Name Url


init : ( Model, Cmd Msg )
init =
    ( Login "", getConfig )


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
        Login url ->
            a [ href url ] [ text "Login" ]

        Logout name url ->
            div []
                [ text "Hi, "
                , text name
                , a [ href url ] [ text "Logout" ]
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
            Logout name config.logoutUrl

        Nothing ->
            Login config.loginUrl


decodeUrl : Json.Decoder Config
decodeUrl =
    Json.object3
        Config
        ("Name" := (Json.maybe Json.string))
        ("LoginUrl" := Json.string)
        ("LogoutUrl" := Json.string)
