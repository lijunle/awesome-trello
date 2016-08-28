module WebAPI.Location exposing (Location, location)

import Native.WebAPI.Location


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


location : Location
location =
    Native.WebAPI.Location.location
