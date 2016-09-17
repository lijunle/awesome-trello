module Component.BoardContainer exposing (Model, Msg, init, update, view)

import Component.BoardSelector as BoardSelector
import Html exposing (..)
import Html.App
import Model exposing (..)


type alias Model =
    { boardSelector : BoardSelector.Model
    , selectedBoard : Maybe Board
    }


type Msg
    = BoardSelectorMsg BoardSelector.Msg


init : Token -> ( Model, Cmd Msg )
init token =
    let
        model =
            { boardSelector = BoardSelector.init [], selectedBoard = Nothing }
    in
        ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BoardSelectorMsg boardSelectorMsg ->
            let
                selectedBoard =
                    BoardSelector.update boardSelectorMsg model.boardSelector

                newModel =
                    { model | selectedBoard = selectedBoard }
            in
                ( newModel, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ model.boardSelector |> BoardSelector.view |> Html.App.map BoardSelectorMsg
        ]
