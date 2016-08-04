module Program

open System
open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Hosting
open Microsoft.AspNetCore.Http

type Startup() =
  member __.Configure(app : IApplicationBuilder) =
    app.Run (fun context -> context.Response.WriteAsync("Hello World"))

[<EntryPoint>]
let main argv =
  WebHostBuilder()
    .UseKestrel()
    .UseIISIntegration()
    .UseStartup<Startup>()
    .Build()
    .Run()

  0 // return an integer exit code
