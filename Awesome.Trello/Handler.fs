module Handler

open Microsoft.AspNetCore.Http
open Newtonsoft.Json
open Newtonsoft.Json.Linq
open System.Net.Http
open System.Threading.Tasks

let httpClient = new HttpClient()

let index (context: HttpContext) =
  context.Response.SendFileAsync "index.html"

let login (context: HttpContext) =
  let schema = context.Request.Scheme
  let host = context.Request.Host.ToString()
  let query = [
    ("expiration", "never")
    ("response_type", "token")
    ("callback_method", "fragment")
    ("scope", "read,write,account")
    ("name", App.name)
    ("key", Trello.key)
    ("redirect_uri", sprintf "%s://%s/auth" schema host)
  ]

  let loginUrl = Url.build Trello.authUrl query
  Task.Run (fun () -> context.Response.Redirect loginUrl)

let logout (context: HttpContext) =
  context.Session.Remove "token"
  Task.Run (fun () -> context.Response.Redirect "/")

let auth (context: HttpContext) =
  let exist, token = context.Request.Query.TryGetValue "token"
  if exist then
    context.Session.SetString ("token", token.ToString())
    Task.Run (fun () -> context.Response.Redirect "/")
  else
    context.Response.SendFileAsync "auth.html"

let javascript (context: HttpContext) =
  context.Response.SendFileAsync "index.js"

type ConfigPayload = {
  Name: string
  Boards: string list
}

let getInfo token : TrelloMember option =
  try
    let query = [
      ("fields", "fullName")
      ("boards", "open")
      ("key", Trello.key)
      ("token", token)
    ]

    let memberUrl = Url.build Trello.memberUrl query
    let result = httpClient.GetStringAsync(memberUrl).Result // TODO use async
    let memberInfo = JsonConvert.DeserializeObject<TrelloMember> result
    Some memberInfo
  with e ->
    None

let config (context: HttpContext) =
  let token = context.Session.GetString "token" |> Option.ofObj
  let info = token |>> getInfo
  let config = {
    Name = info |>> (Trello.Member.fullName >> Some) |> Option.toObj
    Boards = info |>> (Trello.Member.boards >> Some) |>> (List.map Trello.Board.name >> Some) |> Option.defaultValue []
  }

  let content = JsonConvert.SerializeObject(config)
  context.Response.WriteAsync content
