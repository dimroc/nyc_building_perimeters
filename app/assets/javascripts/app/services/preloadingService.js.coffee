class App.PreloadingService extends Spine.Module
  @extend Spine.Events

  @preload: ->
    worldDfd = $.Deferred()
    neighborhoodDfd = $.Deferred()

    App.World.bind 'refresh', -> worldDfd.resolve()
    App.Neighborhood.bind 'refresh', -> neighborhoodDfd.resolve()

    App.World.fetchFromStatic()
    App.Neighborhood.fetchFromStatic()

    completeDfd = $.Deferred()
    $.when(worldDfd, neighborhoodDfd).
      then( -> App.World.first().fetchRegions(-> completeDfd.resolve()))

    completeDfd
