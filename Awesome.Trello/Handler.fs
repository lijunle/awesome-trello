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

  let queryString = query |> List.map (fun (key, value) -> sprintf "%s=%s" key value) |> String.concat "&"
  let loginUrl = sprintf "%s?%s" Trello.authUrl queryString
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
}

let getName token =
  try
    let memberUrl = sprintf "%s?fields=fullName&key=%s&token=%s" Trello.memberUrl Trello.key token // TODO query string
    let result = httpClient.GetStringAsync(memberUrl).Result // TODO use async
    let name = JObject.Parse(result).["fullName"].ToString()
    Some name
  with e ->
    None

let config (context: HttpContext) =
  let token = context.Session.GetString "token" |> Option.ofObj
  let name = Option.bind getName token
  let config = {
    Name = name |> Option.toObj
  }

  let content = JsonConvert.SerializeObject(config)
  context.Response.WriteAsync content
