module Component.BoardSelector exposing (Model, Msg, init, update, view)

import Model exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    { boards : List Board
    }


type Msg
    = SelectBoard String


init : List Board -> Model
init boards =
    { boards = boards }


update : Msg -> Model -> Maybe Board
update msg model =
    case msg of
        SelectBoard boardId ->
            model.boards
                |> List.filter (\x -> x.id == BoardId boardId)
                |> List.head


view : Model -> Html Msg
view model =
    select [ onInput SelectBoard ]
        (model.boards
            |> List.map
                (\x ->
                    option
                        [ value (toBoardIdString x.id) ]
                        [ text (toNameString x.name) ]
                )
        )
