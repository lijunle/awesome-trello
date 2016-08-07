[<AutoOpen>]
module Utils

open System

let (|>>) x f =
  Option.bind f x

module App =
  let name =
    "Awesome.Trello"

module Trello =
  module Board =
    let name (board: TrelloBoard) = board.name
    let id (board: TrelloBoard) = board.id

  module Member =
    let fullName (memberInfo: TrelloMember) = memberInfo.fullName
    let boards (memberInfo: TrelloMember) = memberInfo.boards

  let authUrl =
    "https://trello.com/1/authorize"
  let memberUrl =
    "https://api.trello.com/1/members/me"
  let key =
    Environment.GetEnvironmentVariable "TRELLO_KEY"

module Url =
  let build baseUrl query =
    let queryString = query |> List.map (fun (key, value) -> sprintf "%s=%s" key value) |> String.concat "&"
    let url = sprintf "%s?%s" baseUrl queryString
    url

module Option =
  let defaultValue value option =
    defaultArg option value
