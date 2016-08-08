module Board exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode
import Model exposing (..)
import Task


type alias Model =
    { boards : List Board
    , cards : List Card
    }


type Msg
    = FetchFail Http.Error
    | FetchCardSucceed (List Card)
    | Select Board


init : Config -> ( Model, Cmd Msg )
init config =
    let
        model =
            config |> toModel

        cmd =
            List.head model.boards
                |> Maybe.map getCard
                |> Maybe.withDefault Cmd.none
    in
        ( model, cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchFail error ->
            {- TODO should do something on error? -}
            ( model, Cmd.none )

        FetchCardSucceed cardList ->
            let
                newModel =
                    { model | cards = cardList }
            in
                ( newModel, Cmd.none )

        Select board ->
            ( model, getCard board )


view : Model -> Html Msg
view model =
    if List.isEmpty model.boards then
        div [] []
    else
        div []
            [ viewBoardSelector model.boards
            , viewCardList model.cards
            ]


viewBoardSelector : List Board -> Html Msg
viewBoardSelector boards =
    select [ onInput Select ]
        (boards |> List.map (\x -> option [] [ text x ]))


viewCardList : List Card -> Html Msg
viewCardList cards =
    div []
        [ p []
            [ text "Affecting cards" ]
        , ul
            []
            (cards |> List.map (\x -> li [] [ text x ]))
        ]


toModel : Config -> Model
toModel config =
    Model config.boards []


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
