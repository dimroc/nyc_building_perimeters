class App.World extends App.Model
  @configure 'World', 'id', 'name', 'slug', 'region_names', 'mercator_bounding_box', 'mesh_bounding_box', 'mesh_scale'
  @extend Spine.Model.Ajax
  @url: "#{Constants.apiBasePath}/worlds"

  @hasMany 'regions', "App.Region"

  @allLoaded: false

  @current: ->
    App.World.first()

  @fetchFromStatic: ->
    $.getJSON("#{Constants.staticBasePath}/worlds.json").
      done((data) -> App.World.refresh(data, {clear: true}))

  @findOrFetch: (slug, callback)->
    world = @findByAttribute("slug", slug)
    if world
      callback(world)
    else
      $.ajax(
        type: "GET",
        url: "#{Constants.apiBasePath}/worlds",
        dataType: "json"
      ).success((data) =>
        @refresh(data)
        callback(@findByAttribute("slug", slug))
      ).error (response, status) =>
        console.warn "Failed to fetch worlds: #{response.responseText}"

  @fetchAllDetails: ->
    loaded = 0
    worlds = @all()
    _(worlds).each (world) ->
      world.fetchRegions (world) ->
        World.trigger('loaded', world)

        loaded += 1
        if loaded == worlds.length
          World.allLoaded = true
          World.trigger('allLoaded', worlds)

  constructor: (attributes = {}) ->
    super(attributes)
    @inverse_mesh_scale = 1/@mesh_scale

  validate: ->
    @errors = {}
    @appendErrors(name: "Name is required") unless @name
    @appendErrors(slug: "slug is required") unless @slug

  iconPath: ->
    "/assets/icons/#{_(@name).underscored()}.png"

  fetchRegions: (successCallback)->
    url = "#{Constants.staticBasePath}/#{@slug}/regions.json"
    $.ajax(
      type: "GET",
      url: url,
      dataType: "json"
    ).success((data) =>
      @regions(data)
      @trigger 'loaded', @
      successCallback(@) if successCallback
    ).error (response, status)=>
      console.warn "Error retrieving regions for world #{@slug}"
      console.warn "Received status: #{status}. message: #{response.responseText}"

  outlineMeshes: ->
    _regions = _(@selectedRegions())
    _regions.chain()
      .map((region) -> region.outlineMeshes())
      .flatten()
      .compact()
      .value()

  modelMeshes: ->
    _.chain(@regions().all())
      .map((region) -> region.modelMesh())
      .compact()
      .value()

  transformMercatorToWorld: (mercatorPoint) ->
    x = (mercatorPoint.x - @mercator_bounding_box.min_x) * @mesh_scale
    y = (mercatorPoint.y - @mercator_bounding_box.min_y) * @mesh_scale
    new THREE.Vector3(x, y, 0)

  transformSurfaceToMercator: (surfacePoint) ->
    x = @mercator_bounding_box.min_x + surfacePoint.x * @inverse_mesh_scale
    y = @mercator_bounding_box.min_y + surfacePoint.y * @inverse_mesh_scale
    new THREE.Vector2(x, y)

  transformSurfaceToLonLat: (surfacePoint) ->
    m = @transformSurfaceToMercator(surfacePoint)
    MercatorConverter.m2ll(m.x, m.y)
