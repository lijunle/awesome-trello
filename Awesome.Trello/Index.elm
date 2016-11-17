port module Main exposing (main)

import Html
import Page


main : Program Never Page.Model Page.Msg
main =
    Html.program
        { init = Page.init
        , view = Page.view
        , update = Page.update
        , subscriptions = Page.subscriptions
        }
