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
