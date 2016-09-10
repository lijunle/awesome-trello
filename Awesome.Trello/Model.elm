module Model exposing (..)

{- TODO add strong type Id, Name and Token -}


type alias IncomingPort data msg =
    (data -> msg) -> Sub msg


type alias Id =
    String


type alias Name =
    String


type alias Url =
    String


type alias Board =
    { id : String
    , name : String
    }


type alias Card =
    { id : Id
    , name : Name
    , idMembers : List String
    }


type alias Webhook =
    { id : Id
    , active : Bool
    , idModel : String
    , description : String
    , callbackURL : String
    }


type alias Member =
    { id : Id
    , fullName : Name
    , boards : List Board
    }
