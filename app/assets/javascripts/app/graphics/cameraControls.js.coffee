# TODO: Break up class into two parts:
# Camera and Mouse (I/O)
class App.CameraControls extends Spine.Module
  @extend Spine.Events

  constructor: (camera, domElement) ->
    @camera = camera
    @domElement = (if (domElement isnt `undefined`) then domElement else document)
    @projector = new THREE.Projector()

    @enabled = true
    @screen = width: 0, height: 0

    @zoomSpeed = 2.0
    @panSpeed = .3

    @staticMoving = false
    @dynamicDampingFactor = 0.2
    @minDistance = 9.0
    @maxDistance = 140.0

    @eye = @camera.position.clone()
    @target = new THREE.Vector3(@eye.x, @eye.y + 5, -5)

    @zoomStart = @zoomEnd = 0.0
    @panStart = new THREE.Vector2()
    @panEnd = new THREE.Vector2()

    $(@domElement).bind("mousemove", @mousemove)
    $(@domElement).bind("mousedown", @mousedown)
    $(@domElement).bind("mousewheel", @mousewheel)
    @handleResize()

  destroy: ->
    $(@domElement).unbind()

  mousedown: (event) =>
    return unless @enabled
    @mouseIsDown = true

    @panStart = @panEnd = @_getMouseOnScreen(event.clientX, event.clientY)
    document.body.style.cursor = 'move'
    $(@domElement).bind("mouseup", @mouseup)
    false

  mousemove: (event) =>
    return unless @enabled
    @panning = true if @mouseIsDown

    @mouseOnHtmlScreen = @_getMouseOnScreen(event.clientX, event.clientY)
    @panEnd = @mouseOnHtmlScreen.clone()

    # Convert to screen space coordinates (-1 -> 1 instead of 0 -> 1)
    @mouseOnScreen = @mouseOnHtmlScreen.clone().multiplyScalar(2)
    @mouseOnScreen.x -= 1
    @mouseOnScreen.y -= 1
    @mouseOnScreen.y *= -1

    @mouseRaycaster = @_getMouseRay()
    @mouseOnSurface = @_getMouseOnSurface()

  mouseup: (event) =>
    return unless @enabled
    document.body.style.cursor = 'default'
    $(@domElement).unbind("mouseup", @mouseup)

    wasPanning = @panning
    @panning = false
    @mouseIsDown = false

    App.CameraControls.trigger('selectPoint', @mouseOnSurface, @mouseRaycaster) unless wasPanning
    false

  mousewheel: (event) =>
    return unless @enabled

    wheelDelta = event.originalEvent.wheelDelta
    delta = wheelDelta / 40

    if delta > 0
      @zoomStart += 0.05
    else
      @zoomStart -= 0.05
    false

  handleResize: =>
    @screen.width = window.innerWidth
    @screen.height = window.innerHeight

    @camera.aspect = window.innerWidth / window.innerHeight
    @camera.lookAt(@target)
    @camera.updateProjectionMatrix()

  handleEvent: (event) =>
    this[event.type] event if typeof this[event.type] is "function"

  _getMouseOnScreen: (clientX, clientY) =>
    new THREE.Vector2(clientX / @screen.width, clientY / @screen.height)

  _getMouseRay: ->
    if @mouseOnScreen?
      # @mouseOnScreen.clone()Convert mouse position into a ray pointing into world space
      mouse = new THREE.Vector3(@mouseOnScreen.x, @mouseOnScreen.y, 0)
      @projector.pickingRay(mouse, @camera)

  _getMouseOnSurface: ->
    if @mouseRaycaster?
      ray = @mouseRaycaster.ray
      magnitudeUntilSurface = -ray.origin.z / ray.direction.z
      new THREE.Vector3().addVectors(ray.origin, ray.direction.clone().multiplyScalar(magnitudeUntilSurface))

  mouseToMercator: (world) ->
    if @mouseOnSurface?
      world.transformSurfaceToMercator(@mouseOnSurface)

  mouseToLonLat: (world) ->
    if @mouseOnSurface?
      world.transformSurfaceToLonLat(@mouseOnSurface)

  zoomCamera: ->
    factor = (@zoomEnd - @zoomStart) * -@zoomSpeed
    if factor > 0.001 or factor < -0.001
      if @mouseRaycaster?
        ray = @mouseRaycaster.ray
      else
        ray = new THREE.Ray()
        ray.direction.z = -1

      # Handle z coordinate
      offset = ray.direction.clone().multiplyScalar(factor * 10)
      @eye.z += offset.z

      if @withinZoomDistances()
        # Handle X/Y Coordinate
        pan = @eye.clone().cross(@camera.up).setLength(-offset.x)
        pan.add @camera.up.clone().setLength(offset.y)
        pan.z = 0
        @camera.position.add pan
        @target.add pan

      if @staticMoving
        @zoomStart = @zoomEnd
      else
        @zoomStart += (@zoomEnd - @zoomStart) * @dynamicDampingFactor

  panCamera: ->
    mouseChange = @panEnd.clone().sub(@panStart)
    if mouseChange.lengthSq()
      mouseChange.multiplyScalar @eye.length() * @panSpeed
      pan = @eye.clone().cross(@camera.up).setLength(mouseChange.x)
      pan.add @camera.up.clone().setLength(mouseChange.y)
      @camera.position.add pan
      @target.add pan
      if @staticMoving
        @panStart = @panEnd
      else
        @panStart.add mouseChange.subVectors(@panEnd, @panStart).multiplyScalar(@dynamicDampingFactor)

  withinZoomDistances: ->
    if @eye.z > @maxDistance
      @eye.z = @maxDistance
      false
    else if @eye.z < @minDistance
      @eye.z = @minDistance
      false
    else
      true

  update: ->
    @eye.copy(@camera.position).sub @target
    @zoomCamera()
    @panCamera() if @panning
    @camera.position.addVectors @target, @eye
    @camera.lookAt @target

  navigate: (worldPosition) ->
    that = @
    tween = new TWEEN.Tween(x: @camera.position.x, y: @camera.position.y, z: @camera.position.z)
      .to({x: worldPosition.x, y: worldPosition.y - 3, z: 11}, 1000)
      .easing( Env.tween )
      .onUpdate(-> that._updatePosition(this))
      .start()

  _updatePosition: (position) =>
    @eye = new THREE.Vector3(position.x, position.y, position.z)
    @camera.position = @eye.clone()
    @target = new THREE.Vector3(position.x, position.y + 5, -5)
