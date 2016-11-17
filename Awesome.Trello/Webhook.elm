module Webhook exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Http
import Model exposing (..)
import Request


type alias Model =
    { token : Token
    , webhooks : List Webhook
    }


type Msg
    = FetchWebhooks (Result Http.Error (List Webhook))


init : Token -> ( Model, Cmd Msg )
init token =
    let
        model =
            { token = token
            , webhooks = []
            }

        cmd =
            Request.getWebhooks token
                |> Http.send FetchWebhooks
    in
        ( model, cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchWebhooks (Err error) ->
            {- TODO should do something on error? -}
            ( model, Cmd.none )

        FetchWebhooks (Ok webhooks) ->
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
    li []
        [ div [] [ text webhook.description ]
        , a [] [ text webhook.callbackURL ]
        ]
