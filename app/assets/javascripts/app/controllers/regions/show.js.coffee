$ = jQuery
Region = App.Region
World = App.World

class App.Controller.Regions.Show extends Spine.Controller
  events:
    'click [data-type=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id) if params

  change: (slug) ->
    @item = Region.findByAttribute("slug", slug)

  render: ->
    output = @html @view('regions/show')(@item)
    @worldRenderer = new App.WorldRenderer(World.first(), $(output).find("#world"))
    @worldRenderer.addRegions(@item)
    @worldRenderer.animate()
    @debugController = new App.Controller.Debug($(output))
    output

  back: ->
    @navigate '/regions'

  activate: ->
    super
    @render()

  deactivate: ->
    super
    if @worldRenderer
      @worldRenderer.destroy()
      delete @worldRenderer

    @el.empty()
