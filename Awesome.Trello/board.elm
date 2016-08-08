module Board exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Http
import Task


type alias Board =
    String


type alias Card =
    String


type alias Model =
    { boards : List Board
    , cards : List Card
    }


type Msg
    = Init
    | FetchBoardSucceed Model
    | FetchCardSucceed (List Card)
    | FetchFail Http.Error
    | Select Board


init : ( Model, Cmd Msg )
init =
    ( Model [] [], getConfig )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Init ->
            ( model, Cmd.none )

        FetchBoardSucceed newModel ->
            let
                newCmd =
                    List.head newModel.boards
                        |> Maybe.map getCard
                        |> Maybe.withDefault Cmd.none
            in
                ( newModel, newCmd )

        FetchCardSucceed cardList ->
            let
                newModel =
                    { model | cards = cardList }
            in
                ( newModel, Cmd.none )

        FetchFail error ->
            ( model, Cmd.none )

        Select board ->
            ( model, getCard board )


view : Model -> Html Msg
view model =
    div []
        [ select [ onInput Select ]
            (model.boards |> List.map (\x -> option [] [ text x ]))
        , viewCardList model.cards
        ]


viewCardList : List Card -> Html Msg
viewCardList cards =
    div []
        [ p []
            [ text "Affecting cards" ]
        , ul
            []
            (cards |> List.map (\x -> li [] [ text x ]))
        ]


getConfig : Cmd Msg
getConfig =
    let
        url =
            "/config.json"
    in
        Task.perform
            FetchFail
            FetchBoardSucceed
            (Http.get decodeUrl url)


decodeUrl : Json.Decode.Decoder Model
decodeUrl =
    let
        stringList =
            Json.Decode.list Json.Decode.string
    in
        Json.Decode.map
            (\boards -> Model boards [])
            (Json.Decode.at [ "Boards" ] stringList)


getCard : Board -> Cmd Msg
getCard board =
    let
        url =
            "/card.json?board=" ++ board
    in
        Task.perform
            FetchFail
            FetchCardSucceed
            (Http.get (Json.Decode.list Json.Decode.string) url)
