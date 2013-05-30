class App.Region extends App.Model
  @configure 'Region', 'id', 'name', 'slug', 'current'
  @extend Spine.Model.Ajax
  @url: "#{Constants.apiBasePath}/regions"

  validate: ->
    @errors = {}
    @appendErrors(name: "Name is required") unless @name
    @appendErrors(slug: "slug is required") unless @slug

  iconPath: ->
    "/assets/icons/#{@slug}.png"

  neighborhoodNames: ->
    _(@neighborhoods).map((neighborhood)-> neighborhood.name)

  outlineMeshes: ->
    App.MeshFactory.loadRegionOutlines(@)

  modelMesh: ->
    App.MeshFactory.loadRegionModel(@)
