module WebAPI.Location
    exposing
        ( Location
        , location
        )

{-| Facilities from the browser's `window.location` object.

See the [Mozilla documentation](https://developer.mozilla.org/en-US/docs/Web/API/Location)

For a `Signal`-oriented version of things you might do with `window.location`, see
[TheSeamau5/elm-history](http://package.elm-lang.org/packages/TheSeamau5/elm-history/latest).

@docs Location, location, reload, Source, assign, replace
-}

import Task exposing (Task)
import Native.WebAPI.Location


{-| The parts of a location object. Note `port'`, since `port` is a reserved word.
-}
type alias Location =
    { href : String
    , protocol : String
    , host : String
    , hostname : String
    , port' : String
    , pathname : String
    , search : String
    , hash : String
    , origin : String
    }


{-| The browser's `window.location` object.
-}
location : Task x Location
location =
    Native.WebAPI.Location.location
