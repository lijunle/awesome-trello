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
