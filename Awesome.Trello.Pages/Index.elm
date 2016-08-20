module Main exposing (main)

import Board
import Html exposing (..)
import Html.App
import Http
import Json.Decode
import Login
import Model exposing (..)
import Request
import Task


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias PageModel =
    { login : Login.Model
    , boards : Board.Model
    }


type Model
    = Init
    | Error Http.Error
    | Login Login.Model
    | Page PageModel


init : ( Model, Cmd Msg )
init =
    ( Init, getConfig )


type Msg
    = FetchFail Http.Error
    | FetchSucceed Page
    | LoginMsg Login.Msg
    | BoardMsg Board.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchFail error ->
            ( Error error, Cmd.none )

        FetchSucceed page ->
            case page of
                Nothing ->
                    ( Login (Login.init Nothing), Cmd.none )

                Just ( token, member ) ->
                    let
                        loginModel =
                            Login.init (Just member.fullName)

                        ( boardModel, boardMsg ) =
                            Board.init token member

                        pageModel =
                            { login = loginModel, boards = boardModel }
                    in
                        ( Page pageModel, Cmd.map BoardMsg boardMsg )

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
                ]


viewLogin : Login.Model -> Html Msg
viewLogin loginModel =
    Login.view loginModel |> Html.App.map LoginMsg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


getConfig : Cmd Msg
getConfig =
    Task.andThen getToken getMemberMe
        |> Task.perform FetchFail FetchSucceed


getToken : Task.Task Http.Error (Maybe String)
getToken =
    let
        url =
            "/config.json"

        token =
            Json.Decode.at [ "Token" ] (Json.Decode.maybe Json.Decode.string)
    in
        Http.get token url


getMemberMe : Maybe String -> Task.Task Http.Error Page
getMemberMe maybeToken =
    case maybeToken of
        Nothing ->
            Task.succeed Nothing

        Just token ->
            Request.getMemberMe token
                |> Task.map (\member -> Just ( token, member ))
