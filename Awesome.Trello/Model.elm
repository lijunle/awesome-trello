module Model exposing (..)

{- TODO add strong type Id, Name and Token -}


type Id
    = Id String


toIdString : Id -> String
toIdString id =
    case id of
        Id id ->
            id


type alias Name =
    String


type Url
    = Url String


toUrlString : Url -> String
toUrlString url =
    case url of
        Url url ->
            url


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
