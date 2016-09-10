module Model exposing (..)

{- TODO add strong type Id, Name and Token -}


type BoardId
    = BoardId String


toBoardIdString : BoardId -> String
toBoardIdString boardId =
    case boardId of
        BoardId boardId ->
            boardId


type Id
    = Id String


toIdString : Id -> String
toIdString id =
    case id of
        Id id ->
            id


type Name
    = Name String


toNameString : Name -> String
toNameString name =
    case name of
        Name name ->
            name


type Url
    = Url String


toUrlString : Url -> String
toUrlString url =
    case url of
        Url url ->
            url


type alias Board =
    { id : BoardId
    , name : Name
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
