class App.BuildingGroupRepo
  @instance: ->
    singleton

  constructor: ->
    @_geometryRepo = App.BuildingGeometryRepo.instance()

  load: (neighborhood) ->
    neighborhoods = neighborhood.neighbors()
    neighborhoods.unshift(neighborhood)
    neighborhoods = neighborhoods.slice(0, Env.neighbors + 1)

    loadingPromises = for n in neighborhoods
      @_geometryRepo.load(n)

    dfd = $.Deferred()
    $.when.apply(@, loadingPromises).then(=>
      group = @_updateGroup(neighborhood.slug, neighborhoods)
      dfd.resolve(group))

    dfd

  _updateGroup: (slug, neighborhoods) =>
    group = new THREE.Object3D()
    group.name = "buildingGroup: #{slug}"
    group.isNbcBuilding = true
    for n in neighborhoods
      selected = slug == n.slug
      group.add(@_geometryRepo.createMesh(n.slug, selected))

    group

singleton = new App.BuildingGroupRepo()
