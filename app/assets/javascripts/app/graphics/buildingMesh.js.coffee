class App.BuildingMesh
  @show: (neighborhood) ->
    singleton.show(neighborhood)

  constructor: ->
    @_repo = App.BuildingGroupRepo.instance()

  show: (neighborhood) ->
    @_repo.load(neighborhood).done(@render)

  render: (mesh) =>
    App.WorldRenderer.instance().setBuildings([mesh])

singleton = new App.BuildingMesh()
