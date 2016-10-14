module Main exposing (main)

import Navigation
import Page
import Router


main : Program Never
main =
    Navigation.program (Navigation.makeParser Router.parseHash)
        { init = Page.init
        , view = Page.view
        , update = Page.update
        , urlUpdate = Page.urlUpdate
        , subscriptions = Page.subscriptions
        }
