$ = jQuery
Region = App.Region

$.fn.itemViaSlug = ->
  elementID   = $(@).data('slug')
  elementID or= $(@).parents('[data-slug]').data('slug')
  Region.findByAttribute("slug", elementID)

class App.Controller.Regions.Index extends Spine.Controller
  events:
    'click [data-type=show]':    'show'
    'click [data-type=back]':    'back'

  constructor: ->
    super
    Region.bind 'refresh change', @render

  render: =>
    @html @view('regions/index')(regions: Region.all())

  show: (e) ->
    item = $(e.target).itemViaSlug()
    @navigate '/regions', item.slug

  back: ->
    @navigate '/neighborhoods'
