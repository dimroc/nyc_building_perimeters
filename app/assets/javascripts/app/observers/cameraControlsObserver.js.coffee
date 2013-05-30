class App.CameraControlsObserver extends Spine.Module
  @extend Spine.Events

  constructor: ->
    App.CameraControls.bind('selectPoint', @selectBlockFromPoint)
    App.CameraControls.bind('selectPoint', @selectNeighborhoodFromPoint)

  selectBlockFromPoint: (pointOnSurface)=>
    selectedBlock = _(App.Block.all()).detect((block) ->
      world = App.World.current()
      block.contains(pointOnSurface, world)
    )

    selectedBlock.trigger('selected') if selectedBlock?

  selectNeighborhoodFromPoint: (pointOnSurface, raycaster) =>
    @_selectNeighborhood(App.Neighborhood.at(pointOnSurface, raycaster))

  selectNeighborhoodFromPointAjax: (pointOnSurface) =>
    lonlat = App.World.current().transformSurfaceToLonLat(pointOnSurface)

    $.ajax(
      url: "/api/neighborhoods",
      data: { longitude: lonlat.lon, latitude: lonlat.lat }
    ).done(@_selectNeighborhood)

  _selectNeighborhood: (neighborhood) ->
    return unless neighborhood
    neighborhood = App.Neighborhood.find(neighborhood.id)

    App.RoutingService.navigate neighborhood

singleton = new App.CameraControlsObserver()
