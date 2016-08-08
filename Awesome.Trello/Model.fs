[<AutoOpen>]
module Model

type TrelloBoard = {
  name: string
  id: string
}

type TrelloMember = {
  fullName: string
  boards: TrelloBoard list
}

type TrelloCardMember = {
  id: string
}

type TrelloCard = {
  id: string
  name: string
  members: TrelloCardMember list
}
