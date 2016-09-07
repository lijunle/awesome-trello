port module Main exposing (main)

import Html.App
import Model exposing (..)
import Page
import String


port hashtag : IncomingPort String msg


subscriptions : Page.Model -> Sub Page.Msg
subscriptions model =
    Page.subscriptions (hashtag |> andThen toToken)


main : Program Never
main =
    Html.App.program
        { init = Page.init
        , view = Page.view
        , update = Page.update
        , subscriptions = subscriptions
        }


andThen : (a -> b) -> IncomingPort a msg -> IncomingPort b msg
andThen apply port1 =
    (\port2 -> apply >> port2 |> port1)


toToken : String -> Maybe String
toToken hashtag =
    let
        tokenPrefix =
            "#token="

        tokenPrefixLength =
            String.length tokenPrefix
    in
        if hashtag |> String.startsWith tokenPrefix then
            Just (hashtag |> String.dropLeft tokenPrefixLength)
        else
            Nothing
