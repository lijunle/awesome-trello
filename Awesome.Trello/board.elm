module Board exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Json.Decode
import Http
import Task


type alias Board =
    String


type alias Model =
    { list : List Board
    }


type Msg
    = Init
    | FetchSucceed Model
    | FetchFail Http.Error


init : ( Model, Cmd Msg )
init =
    ( Model [], getConfig )


update : Msg -> Model -> Model
update msg model =
    case msg of
        Init ->
            model

        FetchSucceed newModel ->
            newModel

        FetchFail error ->
            model


view : Model -> Html Msg
view model =
    div []
        [ select []
            (model.list |> List.map (\x -> option [] [ text x ]))
        ]


getConfig : Cmd Msg
getConfig =
    let
        url =
            "/config.json"
    in
        Task.perform FetchFail FetchSucceed (Http.get decodeUrl url)


decodeUrl : Json.Decode.Decoder Model
decodeUrl =
    let
        stringList =
            Json.Decode.list Json.Decode.string
    in
        Json.Decode.map Model (Json.Decode.at [ "Boards" ] stringList)
