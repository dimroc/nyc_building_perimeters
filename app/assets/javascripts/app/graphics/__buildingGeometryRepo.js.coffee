class App.BuildingGeometryRepo
  @instance: ->
    singleton

  constructor: ->
    @_cache = {}

  load: (neighborhood) ->
    dfd = $.Deferred()

    if !@_cache[neighborhood.slug]
      $.getJSON("#{Constants.staticBasePath}/threejs/#{neighborhood.slug}.json").
        done((data) => @_updateCache(neighborhood, data, dfd)).
        fail(-> console.log("Failed to retrieve #{neighborhood.slug} buildings", arguments))
    else
      dfd.resolve(@_cache[neighborhood.slug])

    dfd

  createMesh: (slug, selected) ->
    throw "#{slug} not in repository. load() first?" if !@_cache[slug]
    geometry = @_cache[slug]
    color = 0x00FF00
    color = 0xFF0000 if selected
    buildingMesh = new THREE.Mesh(geometry, new THREE.MeshLambertMaterial({color: color}))

    buildingMesh.name = "buildings: #{slug}"
    buildingMesh.isNbcBuilding = true
    buildingMesh

  trimCache: ->
    @clearCache() if Object.keys(@_cache).length > 8

  clearCache: ->
    @_cache = {}

  _updateCache: (neighborhood, data, dfd) ->
    if !@_cache[neighborhood.slug]
      model = new THREE.JSONLoader().parse(data)
      @_cache[neighborhood.slug] = model.geometry

    dfd.resolve(@_cache[neighborhood.slug])

singleton = new App.BuildingGeometryRepo()
