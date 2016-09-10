module Page exposing (Model, Msg, init, update, view, subscriptions)

import Board
import Html exposing (..)
import Html.App
import Http
import Login
import Model exposing (..)
import Request
import Task
import Webhook


type alias PageModel =
    { login : Login.Model
    , boards : Board.Model
    , webhooks : Webhook.Model
    }


type Model
    = Init
    | Error Http.Error
    | Login Login.Model
    | Page PageModel


init : ( Model, Cmd Msg )
init =
    ( Init, Cmd.none )


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
            ( Error error, Cmd.none )

        FetchSucceed ( token, member ) ->
            let
                ( loginModel, loginMsg ) =
                    Login.init (Just member.fullName)

                ( boardModel, boardMsg ) =
                    Board.init token member

                ( webhookModel, webhookMsg ) =
                    Webhook.init token

                pageModel =
                    { login = loginModel
                    , boards = boardModel
                    , webhooks = webhookModel
                    }

                cmd =
                    [ Cmd.map LoginMsg loginMsg
                    , Cmd.map BoardMsg boardMsg
                    , Cmd.map WebhookMsg webhookMsg
                    ]
                        |> Cmd.batch
            in
                ( Page pageModel, cmd )

        GetToken token ->
            case token of
                Nothing ->
                    let
                        ( loginModel, loginMsg ) =
                            Login.init Nothing
                    in
                        ( Login loginModel, Cmd.map LoginMsg loginMsg )

                Just token ->
                    ( Init, getMemberMe token )

        LoginMsg msg ->
            case model of
                Page pageModel ->
                    let
                        ( loginModel, loginMsg ) =
                            Login.update msg pageModel.login

                        newModel =
                            { pageModel | login = loginModel }
                    in
                        ( Page newModel, Cmd.map LoginMsg loginMsg )

                Login loginModel ->
                    let
                        ( newModel, loginMsg ) =
                            Login.update msg loginModel
                    in
                        ( Login newModel, Cmd.map LoginMsg loginMsg )

                _ ->
                    ( model, Cmd.none )

        BoardMsg msg ->
            case model of
                Page pageModel ->
                    let
                        ( boardModel, boardMsg ) =
                            Board.update msg pageModel.boards

                        newModel =
                            { pageModel | boards = boardModel }
                    in
                        ( Page newModel, Cmd.map BoardMsg boardMsg )

                _ ->
                    ( model, Cmd.none )

        WebhookMsg msg ->
            case model of
                Page pageModel ->
                    let
                        ( webhookModel, webhookMsg ) =
                            Webhook.update msg pageModel.webhooks

                        newModel =
                            { pageModel | webhooks = webhookModel }
                    in
                        ( Page newModel, Cmd.map WebhookMsg webhookMsg )

                _ ->
                    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        Init ->
            div [] [ text "Loading..." ]

        Error error ->
            div []
                [ text "Error happens: "
                , text (toString error)
                ]

        Login loginModel ->
            viewLogin loginModel

        Page pageModel ->
            div []
                [ (viewLogin pageModel.login)
                , Board.view pageModel.boards |> Html.App.map BoardMsg
                , Webhook.view pageModel.webhooks |> Html.App.map WebhookMsg
                ]


viewLogin : Login.Model -> Html Msg
viewLogin loginModel =
    Login.view loginModel |> Html.App.map LoginMsg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


getMemberMe : String -> Cmd Msg
getMemberMe token =
    Request.getMemberMe token
        |> Task.map (\member -> ( token, member ))
        |> Task.perform FetchFail FetchSucceed
