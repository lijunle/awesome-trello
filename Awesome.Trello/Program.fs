module Program

open System
open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Hosting
open Microsoft.AspNetCore.Http
open Microsoft.AspNetCore.Routing
open Microsoft.Extensions.DependencyInjection
open Microsoft.Extensions.Logging

type Startup() =
  member __.ConfigureServices(services: IServiceCollection): unit =
    services
      .AddRouting()
      .AddDistributedMemoryCache()
      .AddSession(fun options -> options.CookieName <- App.name)
      |> ignore

  member __.Configure(app: IApplicationBuilder, env: IHostingEnvironment, loggerFactory: ILoggerFactory): unit =
    if env.IsDevelopment() then
      loggerFactory.AddConsole() |> ignore
      app.UseDeveloperExceptionPage() |> ignore

    app.UseSession() |> ignore

    let routerBuilder = RouteBuilder(app)
    routerBuilder.MapGet("", Handler.index) |> ignore
    routerBuilder.MapGet("login", Handler.login) |> ignore
    routerBuilder.MapGet("logout", Handler.logout) |> ignore
    routerBuilder.MapGet("auth", Handler.auth) |> ignore
    routerBuilder.MapGet("index.js", Handler.javascript) |> ignore
    routerBuilder.MapGet("config.json", Handler.config) |> ignore
    routerBuilder.MapGet("card.json", Handler.card) |> ignore
    routerBuilder.MapGet("board-members.json", Handler.members) |> ignore
    routerBuilder.MapPost("board/assign", Handler.assignBoard) |> ignore
    app.UseRouter(routerBuilder.Build()) |> ignore

[<EntryPoint>]
let main argv =
  WebHostBuilder()
    .UseKestrel()
    .UseIISIntegration()
    .UseStartup<Startup>()
    .Build()
    .Run()

  0 // return an integer exit code
