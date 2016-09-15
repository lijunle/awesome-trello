module Component.Card exposing (Model, Msg, init)

import Model exposing (..)
import Http
import Request
import Task
import Html exposing (..)


type alias Model =
    { cards : List Card
    }


type Msg
    = FetchFail Http.Error
    | FetchSucceed (List Card)


init : Token -> Board -> ( Model, Cmd Msg )
init token selectedBoard =
    let
        model =
            { cards = []
            }

        cmd =
            getCard token selectedBoard
    in
        ( model, cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchFail error ->
            ( model, Cmd.none )

        FetchSucceed cards ->
            ( { model | cards = cards }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ p []
            [ text "Affecting cards" ]
        , ul
            []
            (model.cards
                |> List.map
                    (\x ->
                        li [] [ text (toNameString x.name) ]
                    )
            )
        ]


getCard : Token -> Board -> Cmd Msg
getCard token board =
    Request.getBoardCards token board
        |> Task.perform FetchFail FetchSucceed
