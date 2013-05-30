class App.RoutingService
  @navigate: (neighborhood) ->
    Spine.Route.navigate("/neighborhoods/#{neighborhood.slug}")
