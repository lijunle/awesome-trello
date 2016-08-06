[<AutoOpen>]
module Utils

open System

module App =
  let name =
    "Awesome.Trello"

module Trello =
  let authUrl =
    "https://trello.com/1/authorize"
  let key =
    Environment.GetEnvironmentVariable "TRELLO_KEY"
