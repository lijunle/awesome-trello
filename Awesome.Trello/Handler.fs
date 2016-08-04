module Handler

open Microsoft.AspNetCore.Http

let index (context: HttpContext) =
  context.Response.WriteAsync("Hello World")
