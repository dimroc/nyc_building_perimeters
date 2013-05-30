#TODO: Pull out of WorldRenderer and place into DebugController. Take worldRenderer in ctor
class App.DebugRenderer
  constructor: (world, camera, cameraControls) ->
    @world = world
    @debugScene = new THREE.Scene()
    @camera = camera
    @controls = cameraControls

    @mouseRayLine = @generateLineForMouseRay()
    @debugScene.add(@mouseRayLine)

  update: (delta) ->
    @updateMouseRayLine()
    @updateDebugMouseGeographyView()
    @updateMouseCoordinatesView()

  updateDebugMouseGeographyView: ->
    mercator = @controls.mouseToMercator(@world)
    if mercator?
      $(".debug .mercator > .x").text(mercator.x.toFixed(5))
      $(".debug .mercator > .y").text(mercator.y.toFixed(5))

    lonlat = @controls.mouseToLonLat(@world)
    if lonlat?
      $(".debug .lonlat > .x").text(lonlat.lon.toFixed(5))
      $(".debug .lonlat > .y").text(lonlat.lat.toFixed(5))

  generateLineForMouseRay: ->
    material = new THREE.LineBasicMaterial({color: 0xFF0000, linewidth: 3})
    geometry = new THREE.Geometry()
    geometry.vertices.push(new THREE.Vector3())
    geometry.vertices.push(new THREE.Vector3())
    new THREE.Line(geometry, material)

  updateMouseRayLine: ->
    if @controls.mouseRay?
      ray = @controls.mouseRay
      @mouseRayLine.geometry.vertices[0].copy ray.origin

      destination = new THREE.Vector3().addVectors(ray.origin, ray.direction.clone().multiplyScalar(300))
      @mouseRayLine.geometry.vertices[1].copy destination
      @mouseRayLine.geometry.verticesNeedUpdate = true

  updateMouseCoordinatesView: ->
    return unless @controls.mouseOnScreen? and @controls.mouseOnSurface?

    mouseOnScreen = @controls.mouseOnScreen.clone()
    fixedDecimals = 5
    $(".debug .screen > .x").text(mouseOnScreen.x.toFixed(fixedDecimals))
    $(".debug .screen > .y").text(mouseOnScreen.y.toFixed(fixedDecimals))

    surfacePoint = @controls.mouseOnSurface.clone()
    $(".debug .world > .x").text(surfacePoint.x.toFixed(fixedDecimals))
    $(".debug .world > .y").text(surfacePoint.y.toFixed(fixedDecimals))


