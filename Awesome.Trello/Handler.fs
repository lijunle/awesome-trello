module Handler

open Microsoft.AspNetCore.Http

let index (context: HttpContext) =
  context.Response.SendFileAsync("index.html")

let javascript (context: HttpContext) =
  context.Response.SendFileAsync("index.js")
