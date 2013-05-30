class App.Neighborhood extends App.Model
  @configure 'Neighborhood', 'id', 'name', 'borough', 'slug', 'geometry'
  @extend Spine.Model.Ajax
  @url: "#{Constants.apiBasePath}/neighborhoods"
  @threejsLoader: new THREE.JSONLoader()

  @fetchFromStatic: ->
    $.getJSON("#{Constants.staticBasePath}/neighborhoods.json").
      done((data) -> App.Neighborhood.refresh(data, {clear: true}))

  @at: (pointOnSurface, raycaster) ->
    for neighborhood in App.Neighborhood.all()
      return neighborhood if neighborhood.contains(pointOnSurface, raycaster)
    null

  constructor: (attributes = {}) ->
    super(attributes)
    @shape = App.Neighborhood.threejsLoader.parse(@threejs).geometry
    @shape.computeBoundingBox()
    @shapeMesh = new THREE.Mesh(@shape)

  neighbors: ->
    for id in @neighborIds
      App.Neighborhood.find(id)

  contains: (pointOnSurface, raycaster) ->
    hasPoint = @shape.boundingBox.containsPoint(pointOnSurface)
    if hasPoint && raycaster
      raycaster.intersectObject(@shapeMesh).length > 0
    else
      hasPoint

  worldCenter: ->
    center = @shape.boundingBox.min.clone().add(@shape.boundingBox.max)
    center.divideScalar(2)
