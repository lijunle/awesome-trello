module Model exposing (..)

{- TODO add strong type Id, Name and Token -}


type alias Id =
    String


type alias Name =
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


type alias Member =
    { id : Id
    , fullName : Name
    , boards : List Board
    }


type alias Page =
    Maybe ( String, Member )
