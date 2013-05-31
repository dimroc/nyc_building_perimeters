$ = jQuery
World = App.World
Region = App.Region
Block = App.Block
Neighborhood = App.Neighborhood

$.fn.regionViaSlug = ->
  elementID   = $(@).data('slug')
  elementID or= $(@).parents('[data-slug]').data('slug')
  Region.findByAttribute("slug", elementID)

class App.Controller.Neighborhoods extends Spine.Controller
  className: 'neighborhoods'

  events:
    'click [data-type=index]':   'index'
    'click [data-type=show]':    'show'

  constructor: ->
    super
    @showLoadingCount = 0
    $(document).ajaxStart(@_showLoading)
    $(document).ajaxStop(@_hideLoading)
    @active (params) -> @change(params.id)

  change: (slug) ->
    @render()
    neighborhood = App.Neighborhood.findByAttribute("slug", slug)
    neighborhood.trigger('selected') if neighborhood

  render: =>
    return if @worldRenderer?

    world = World.first()
    output = @html @view('neighborhoods/index')(regions: world.regions().all())

    # TODO: worldRenderer should be a singleton service and consumer should communicate
    # with it via events
    @worldRenderer = new App.WorldRenderer(world, $(output).find("#world"))
    @worldRenderer.loadNeighborhoods()

    _(world.regions().all()).each (region) =>
      @worldRenderer.addRegions(region)

    @worldRenderer.animate()

    @debugController = new App.Controller.Debug(output)
    @addBlockModalController = new App.Controller.AddBlockModal(output, @worldRenderer)
    @userPanelController = new App.Controller.UserPanel()

    Spine.trigger('ready')

  index: (e) ->
    @navigate '/neighborhoods'

  show: (e) ->
    item = $(e.target).regionViaSlug()
    @navigate '/neighborhoods', item.slug

  activate: =>
    @render()
    @el.fadeIn(=> @el.addClass("active"))
    @

  deactivate: =>
    if @worldRenderer?
      @worldRenderer.destroy() if @worldRenderer?
      delete @worldRenderer
      @el.empty()

  _showLoading: =>
    @showLoadingCount++
    $(".loading").show()

  _hideLoading: =>
    @showLoadingCount--
    if @showLoadingCount <= 0
      $(".loading").hide()
      @showLoadingCount = 0
