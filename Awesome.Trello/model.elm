module Model exposing (..)


type alias Name =
    String


type alias Board =
    String


type alias Card =
    String


type alias Config =
    { name : Maybe Name
    , boards : List Board
    }
