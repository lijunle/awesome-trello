module Page exposing (Model, Msg, init, update, view, subscriptions)

import Board
import Html exposing (..)
import Html.App
import Http
import Login
import Model exposing (..)
import Request
import String
import Task
import WebAPI.Location
import Webhook


type alias Model =
    { error : Maybe Http.Error
    , login : Login.Model
    , boards : Maybe Board.Model
    , webhooks : Maybe Webhook.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        ( loginModel, loginMsg ) =
            Login.init Nothing

        model =
            { error = Nothing
            , login = loginModel
            , boards = Nothing
            , webhooks = Nothing
            }

        getTokenCmd =
            WebAPI.Location.location
                |> Task.map getToken
                |> Task.perform FetchFail GetToken

        loginCmd =
            Cmd.map LoginMsg loginMsg

        cmd =
            Cmd.batch [ getTokenCmd, loginCmd ]
    in
        ( model, cmd )


type Msg
    = FetchFail Http.Error
    | FetchSucceed ( String, Member )
    | GetToken (Maybe String)
    | LoginMsg Login.Msg
    | BoardMsg Board.Msg
    | WebhookMsg Webhook.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchFail error ->
            ( { model | error = Just error }, Cmd.none )

        FetchSucceed ( token, member ) ->
            let
                ( loginModel, loginMsg ) =
                    Login.init (Just member.fullName)

                ( boardModel, boardMsg ) =
                    Board.init token member

                ( webhookModel, webhookMsg ) =
                    Webhook.init token

                newModel =
                    { model
                        | login = loginModel
                        , boards = Just boardModel
                        , webhooks = Just webhookModel
                    }

                cmd =
                    [ Cmd.map LoginMsg loginMsg
                    , Cmd.map BoardMsg boardMsg
                    , Cmd.map WebhookMsg webhookMsg
                    ]
                        |> Cmd.batch
            in
                ( newModel, cmd )

        GetToken token ->
            case token of
                Nothing ->
                    ( model, Cmd.none )

                Just token ->
                    ( model, getMemberMe token )

        LoginMsg loginMsg ->
            model.login
                |> updateLogin model loginMsg

        BoardMsg boardMsg ->
            model.boards
                |>> (updateBoards model boardMsg)
                ||> ( model, Cmd.none )

        WebhookMsg webhookMsg ->
            model.webhooks
                |>> (updateWebhooks model webhookMsg)
                ||> ( model, Cmd.none )


updateLogin : Model -> Login.Msg -> Login.Model -> ( Model, Cmd Msg )
updateLogin model loginMsg loginModel =
    let
        ( newModel, newMsg ) =
            Login.update loginMsg loginModel
    in
        ( { model | login = newModel }
        , Cmd.map LoginMsg newMsg
        )


updateBoards : Model -> Board.Msg -> Board.Model -> ( Model, Cmd Msg )
updateBoards model boardMsg boardModel =
    let
        ( newModel, newMsg ) =
            Board.update boardMsg boardModel
    in
        ( { model | boards = Just newModel }
        , Cmd.map BoardMsg newMsg
        )


updateWebhooks : Model -> Webhook.Msg -> Webhook.Model -> ( Model, Cmd Msg )
updateWebhooks model webhookMsg webhookModel =
    let
        ( newModel, newMsg ) =
            Webhook.update webhookMsg webhookModel
    in
        ( { model | webhooks = Just newModel }
        , Cmd.map WebhookMsg newMsg
        )


view : Model -> Html Msg
view model =
    case model.error of
        Just error ->
            div []
                [ text "Error happens: "
                , text (toString error)
                ]

        _ ->
            div []
                [ model.login |> Login.view |> Html.App.map LoginMsg
                , model.boards |>> (Board.view >> Html.App.map BoardMsg) ||> nothing
                , model.webhooks |>> (Webhook.view >> Html.App.map WebhookMsg) ||> nothing
                ]


(|>>) : Maybe a -> (a -> b) -> Maybe b
(|>>) maybe f =
    maybe |> Maybe.map f


(||>) : Maybe a -> a -> a
(||>) maybe value =
    maybe |> Maybe.withDefault value


nothing : Html msg
nothing =
    text ""


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


getMemberMe : String -> Cmd Msg
getMemberMe token =
    Request.getMemberMe token
        |> Task.map (\member -> ( token, member ))
        |> Task.perform FetchFail FetchSucceed


getToken : WebAPI.Location.Location -> Maybe String
getToken location =
    let
        hashtag =
            location.hash

        tokenPrefix =
            "#token="

        tokenPrefixLength =
            String.length tokenPrefix
    in
        if hashtag |> String.startsWith tokenPrefix then
            Just (hashtag |> String.dropLeft tokenPrefixLength)
        else
            Nothing
