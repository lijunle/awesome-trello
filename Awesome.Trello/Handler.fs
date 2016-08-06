module Handler

open Microsoft.AspNetCore.Http
open Newtonsoft.Json
open System.Threading.Tasks

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
  LoginUrl: string
  LogoutUrl: string
}

let config (context: HttpContext) =
  let token = context.Session.GetString "token"
  let config = {
    Name = token // TODO
    LoginUrl = "/login"
    LogoutUrl = "/logout"
  }

  let content = JsonConvert.SerializeObject(config)
  context.Response.WriteAsync content
