module Webhook exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Http
import Model exposing (..)


type alias Model =
    { token : String
    , webhooks : List Webhook
    }


type Msg
    = FetchFail Http.Error
    | FetchSucceed (List Webhook)


init : String -> ( Model, Cmd Msg )
init token =
    let
        model =
            { token = token
            , webhooks = []
            }
    in
        ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchFail error ->
            {- TODO should do something on error? -}
            ( model, Cmd.none )

        FetchSucceed webhooks ->
            let
                newModel =
                    { model | webhooks = webhooks }
            in
                ( newModel, Cmd.none )


view : Model -> Html Msg
view model =
    if List.isEmpty model.webhooks then
        div []
            [ text "No webhooks" ]
    else
        div []
            [ p [] [ text "Existing webhooks:" ]
            , ul [] (model.webhooks |> List.map viewWebhook)
            ]


viewWebhook : Webhook -> Html Msg
viewWebhook webhook =
    text webhook.description
