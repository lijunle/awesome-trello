module Model exposing (..)

{- TODO add strong type Id, Name and Token -}


type BoardId
    = BoardId String


toBoardIdString : BoardId -> String
toBoardIdString boardId =
    case boardId of
        BoardId boardId ->
            boardId


type CardId
    = CardId String


toCardIdString : CardId -> String
toCardIdString cardId =
    case cardId of
        CardId cardId ->
            cardId


type MemberId
    = MemberId String


toMemberIdString : MemberId -> String
toMemberIdString memberId =
    case memberId of
        MemberId memberId ->
            memberId


type WebhookId
    = WebhookId String


toWebhookIdString : WebhookId -> String
toWebhookIdString webhookId =
    case webhookId of
        WebhookId webhookId ->
            webhookId


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
    { id : CardId
    , name : Name
    , idMembers : List MemberId
    }


type alias Webhook =
    { id : WebhookId
    , active : Bool
    , idModel : BoardId {- We only care about board ID now -}
    , description : String
    , callbackURL : String
    }


type alias Member =
    { id : MemberId
    , fullName : Name
    , boards : List Board
    }
