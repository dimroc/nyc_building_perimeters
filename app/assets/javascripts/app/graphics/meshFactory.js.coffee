class App.MeshFactory
  @loadRegionModel: (region) ->
    return null unless Object.keys(region.threejs).length > 0

    loader = new THREE.JSONLoader()
    color = 0x000000
    material = new THREE.MeshBasicMaterial({color:color})
    material.wireframe = true if Env.boroughs == "wireframe"

    mesh = null
    parsed = loader.parse(region.threejs.model)
    mesh = new THREE.Mesh( parsed.geometry, material )
    mesh.name = "region-#{region.name}"
    mesh

  @loadRegionOutlines: (region) ->
    return null unless Object.keys(region.threejs).length > 0

    material = new THREE.LineBasicMaterial({color: 0x0000FF, linewidth: 1, opacity: 1})

    lineMeshes = for outline in region.threejs.outlines then do (outline) ->
      lineGeometry = new THREE.Geometry()

      xPoints = []
      yPoints = []
      xPoints.push point for point in outline by 2
      yPoints.push point for point in outline[1..] by 2

      points = _.zip(xPoints, yPoints)
      for point in points then do (point) ->
        lineGeometry.vertices.push(new THREE.Vector3(point[0], point[1], 0))

      new THREE.Line(lineGeometry, material)

  @generateBlock: (world, block) ->
    return null unless block

    if block.encoded()
      texture = THREE.ImageUtils.loadTexture(block.userPhotoProxy())
      currentMaterial = new THREE.MeshBasicMaterial({map: texture, opacity: 1})
    else
      currentMaterial = new THREE.MeshBasicMaterial({color: new THREE.Color(0xFF0000), opacity: 1})

    cubeGeom = new THREE.CubeGeometry(App.Block.WIDTH, App.Block.HEIGHT, App.Block.DEPTH)
    cubeMesh = new THREE.Mesh(cubeGeom, currentMaterial)
    cubeMesh.position = block.worldPosition(world)
    cubeMesh

  @generateFromGeoJson: (geoJson, options) ->
    # http://stackoverflow.com/questions/13442153/errors-extruding-shapes-with-three-js
    switch geoJson.type
      when "MultiPolygon" then MeshFactory.generateFromMultiPolygon(geoJson.coordinates, options)
      else throw "Cannot generate line from GeoJSON type #{geoJson.type}"

  @generateFromMultiPolygon: (coordinates, options) ->
    geoms = for polygon in coordinates
      App.MeshFactory.generateFromPolygon(polygon, options)
    _(geoms).flatten()

  @generateFromPolygon: (polygon, options) ->
    options = options || {}
    _.defaults(options,{ extrude: 0.1, ignoreLidFaces: false })

    shape = new THREE.Shape(projectRing(polygon[0]))
    shape.holes = for hole in polygon.slice(1)
      new THREE.Shape(projectRing(hole))

    extrudeOptions = { amount: options.extrude, bevelEnabled: false, ignoreLidFaces: options.ignoreLidFaces }
    new THREE.ExtrudeGeometry(shape, extrudeOptions)

  @mergeMeshes: (geoms) ->
    geometry = new THREE.Geometry()
    _(geoms).each((geom) -> THREE.GeometryUtils.merge(geometry, geom))
    geometry

projectRing = (ring) ->
  _(ring).map(projectPoint)

projectPoint = (coord) ->
  point = { x: coord[0], y: coord[1] }
  App.World.current().transformMercatorToWorld(point)

fallbackMercatorToWorld = (point) ->
  x = (point.x - -8266094.619172799) * 0.00142857142857143
  y = (point.y - 4910511.427062279) * 0.00142857142857143
  new THREE.Vector3(x, y, 0)
