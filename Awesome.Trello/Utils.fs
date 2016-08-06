[<AutoOpen>]
module Utils

open System

module App =
  let name =
    "Awesome.Trello"

module Trello =
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
