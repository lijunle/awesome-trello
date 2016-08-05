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
    services.AddRouting() |> ignore

  member __.Configure(app: IApplicationBuilder, env: IHostingEnvironment, loggerFactory: ILoggerFactory): unit =
    if env.IsDevelopment() then
      loggerFactory.AddConsole() |> ignore
      app.UseDeveloperExceptionPage() |> ignore

    let routerBuilder = RouteBuilder(app)
    routerBuilder.MapGet("", Handler.index) |> ignore
    routerBuilder.MapGet("index.js", Handler.javascript) |> ignore
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
