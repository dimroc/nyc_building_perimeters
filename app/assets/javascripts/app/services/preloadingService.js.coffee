class App.PreloadingService extends Spine.Module
  @extend Spine.Events

  @preload: ->
    worldDfd = $.Deferred()
    nmeshDfd = $.Deferred()
    neighborhoodDfd = $.Deferred()

    App.World.bind 'refresh', -> worldDfd.resolve()
    App.NeighborhoodMesh.bind 'refresh', -> nmeshDfd.resolve()
    App.Neighborhood.bind 'refresh', -> neighborhoodDfd.resolve()

    App.World.fetchFromStatic()
    App.NeighborhoodMesh.fetchBatch()
    App.Neighborhood.fetchFromStatic()

    completeDfd = $.Deferred()
    $.when(worldDfd, nmeshDfd, neighborhoodDfd).
      then( -> App.World.first().fetchRegions(-> completeDfd.resolve()))

    completeDfd
