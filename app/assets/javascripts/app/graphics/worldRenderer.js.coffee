class App.WorldRenderer extends Spine.Module
  @extend Spine.Events

  worldRenderers = []

  @all: -> worldRenderers
  @first: -> worldRenderers[0]
  @instance: -> worldRenderers[0]
  @create: () -> new WorldRenderer()

  constructor: (world, domElement) ->
    if ( ! Detector.webgl )
      Detector.addGetWebGLMessage()

    console.debug("Creating worldRenderer...")
    @world = world
    @regions = []
    @clock = new THREE.Clock()
    @stats = new App.StatsRenderer()

    options = calculate_options()
    @renderer = createRenderer(options)
    @composer = createComposer(options, @)
    @camera = createPerspectiveCamera(options)

    @regionScene = new THREE.Scene()
    @blockScene = createScene()

    @_attachToDom(domElement)
    @controls = new App.CameraControls(@camera, domElement)
    @debugRenderer = new App.DebugRenderer(@world, @camera, @controls)

    worldRenderers.push(@)

  destroy: ->
    console.debug("Destroying worldRenderer...")

    @destroyed = true
    @controls.destroy()
    @stats.destroy()
    cancelAnimationFrame @requestId
    window.removeEventListener( 'resize', @onWindowResize, false )
    worldRenderers = _(worldRenderers).reject (worldRenderer) => worldRenderer == @

  _attachToDom: (domElement)->
    @domElement = domElement
    $(domElement).append(@renderer.domElement)
    @stats.attachToDom(domElement)
    window.addEventListener( 'resize', @onWindowResize, false )
    @

  onWindowResize: ( event ) =>
    options = calculate_options()
    @composer = createComposer(options, @)
    @renderer.setSize( options.width, options.height )
    @controls.handleResize()

  animate: (elapsedTicks)=>
    delta = @clock.getDelta()

    @update(delta)
    @render(delta)

    if @destroyed
      cancelAnimationFrame @requestId
      console.debug("Animating after destruction...")
    else
      @requestId = requestAnimationFrame(@animate)

  update: (delta) ->
    TWEEN.update()
    @controls.update(delta)
    @debugRenderer.update(delta) if Env.debug
    @stats.update()

  render: (delta) ->
    @composer.render(delta)

  addRegionMeshes: (meshParam)->
    _.each(coerceIntoArray(meshParam), (mesh) ->
      @regionScene.add( mesh )
    , @)
    @

  reloadBlocks: (blocks) ->
    @blockScene = createScene()
    _.each(coerceIntoArray(blocks), (block) ->
      @blockScene.add(block.mesh(@world))
    , @)
    @

  addRegions: (regions)->
    @regions = @regions.concat coerceIntoArray(regions)
    @reloadRegions()

  reloadRegions: ->
    @regionScene = new THREE.Scene()
    _(@regions).each (region) =>
      #@addRegionMeshes(region.outlineMeshes())
      @addRegionMeshes(region.modelMesh())

  loadNeighborhoods: ->
    mesh = App.NeighborhoodMesh.batch()

    @neighborhoodScene = createScene()
    @neighborhoodScene.add(mesh)

  setBuildings: (buildingMeshes) ->
    @buildingScene = @buildingScene || createScene()
    resetScene(@buildingScene)

    for mesh in buildingMeshes
      @buildingScene.add(mesh)

    # Intentionally clear cache so the process can GC
    # Otherwise, we run out of memory as the user clicks on 'hoods
    App.BuildingGeometryRepo.instance().trimCache()

# privates

coerceIntoArray = (meshParam) ->
  # Simply convert meshParam into an array if it isn't one already
  if _.isArray(meshParam) then meshParam else [meshParam]

createOrthographicCamera = (options) ->
  camera = new THREE.OrthographicCamera( options.width / - 2, options.width / 2, options.height / 2, options.height / - 2,  1, 100 )
  camera.position = new THREE.Vector3(250, 0, 100)
  camera.lookAt(new THREE.Vector3(250, 0, 0))
  camera

createPerspectiveCamera = (options) ->
  camera = new THREE.PerspectiveCamera( options.fov, options.width / options.height, 1, 1000 )
  camera.position = new THREE.Vector3(50, 50, 120)
  camera

createRenderer = (options) ->
  renderer = new THREE.WebGLRenderer({antialias: true})

  renderer.setSize( options.width, options.height )
  renderer.setClearColor( 0xffffff, 1 )
  renderer.autoClear = false
  renderer.autoClearColor = false
  renderer.sortObjects = false
  renderer

createComposer = (options, worldRenderer) ->
  composer = new THREE.EffectComposer( worldRenderer.renderer, createRenderTarget(options) )

  worldPass = new App.WorldPass ( worldRenderer )
  worldPass.renderToScreen = true

  #pass = new THREE.ShaderPass( THREE.CopyShader )
  #pass.renderToScreen = true

  #pass = new THREE.FilmPass(1, 0.5, 4096 * 2, 0)
  #pass.renderToScreen = true

  #fxaaShader = _.extend({}, THREE.FXAAShader)
  #fxaaShader.uniforms.resolution.value =
    #new THREE.Vector2( 1 / options.width, 1 / options.height )

  #fxaaPass = new THREE.ShaderPass(fxaaShader)
  #fxaaPass.renderToScreen = true

  composer.addPass( worldPass )
  #composer.addPass( pass )
  #composer.addPass( fxaaPass )
  composer

createRenderTarget = (options) ->
  renderTargetParameters = {
    minFilter: THREE.NearestFilter,
    magFilter: THREE.NearestFilter,
    format: THREE.RGBFormat
  }

  new THREE.WebGLRenderTarget(
    options.width,
    options.height,
    renderTargetParameters)

createDirectionalLight = (options) ->
  # White directional light at half intensity shining from the top.
  directionalLight = new THREE.DirectionalLight( 0xffffff, 0.7 )
  directionalLight.position.set(40, 40, 40)
  directionalLight.lookAt(new THREE.Vector3(40, 40, 0))
  directionalLight

createAmbientLight = (options) ->
  light = new THREE.AmbientLight( 0x333333 )

calculate_options = ->
  {
    fov: 45
    width: window.innerWidth
    height: window.innerHeight
  }

createScene = ->
  scene = new THREE.Scene()
  scene.add(createAmbientLight())
  scene.add(createDirectionalLight())
  scene

resetScene = (scene) ->
  _(scene.children).each((object) ->
    scene.remove(object) if object.isNbcBuilding)
