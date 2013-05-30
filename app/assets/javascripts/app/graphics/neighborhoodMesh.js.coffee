class App.NeighborhoodMesh extends Spine.Module
  @extend Spine.Events

  @fetchBatch: ->
    $.getJSON("#{Constants.staticBasePath}/threejs/neighborhoodsBatch.json").
      done((data) =>
        @_batchGeometry = new THREE.JSONLoader().parse(data).geometry
        material = new THREE.MeshLambertMaterial({color: 0x00FF00, wireframe: Env.neighborhoods == "wireframe"})
        @_batchMesh = new THREE.Mesh(@_batchGeometry, material)
        @trigger('refresh')
      )

  @batch: ->
    @_batchMesh

  @resetMaterial: ->
    @_batchMesh.material.wireframe = Env.neighborhoods == "wireframe"

  @all: ->
    meshes = for neighborhood in App.Neighborhood.all()
      App.NeighborhoodMesh.find(neighborhood.id)

    meshes = _(meshes).flatten()

  @find: (neighborhoodId) ->
    if !@_cache[neighborhoodId]
      @_cache[neighborhoodId] = @_generateMesh(App.Neighborhood.find(neighborhoodId))
    @_cache[neighborhoodId]

  @_generateMesh: (neighborhood) ->
    geometries = App.MeshFactory.generateFromGeoJson(neighborhood.geometry, {ignoreLidFaces: true})
    geometry = App.MeshFactory.mergeMeshes(geometries)

    mesh = new THREE.Mesh(geometry, new THREE.MeshLambertMaterial({color: 0x00FF00}) )
    mesh.material.wireframe = true if Env.neighborhoods == "wireframe"
    mesh

  @_cache: {}
