port module Main exposing (main)

import Html.App
import Page


main : Program Never
main =
    Html.App.program
        { init = Page.init
        , view = Page.view
        , update = Page.update
        , subscriptions = Page.subscriptions
        }
