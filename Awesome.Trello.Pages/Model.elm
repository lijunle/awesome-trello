module Model exposing (..)


type alias Id =
    String


type alias Name =
    String


type alias Board =
    { id : String
    , name : String
    }


type alias Card =
    String


type alias Member =
    { id : Id
    , fullName : Name
    }


type alias Config =
    { token : Maybe String
    , name : Maybe Name
    , boards : List Board
    }
