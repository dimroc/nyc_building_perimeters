#= require json2
#= require jquery
#= require spine
#= require spine/manager
#= require spine/ajax
#= require spine/route
#= require spine/relation

#= require_tree ./lib
#= require_self

#= require_tree ./services/
#= require_tree ./graphics

#= require ./models/model
#= require_tree ./models

#= require_tree ./observers

#= require ./controllers/controller
#= require_tree ./controllers/
#= require_tree ./controllers/regions
#= require ./root

#= require_tree ./views

class App extends Spine.Controller
  constructor: ->
    super

    # Initialize controllers:
    #  @append(@items = new App.Items)
    #  ...

    App.World.one('loaded', @_loadCallback)
    @append(@rootController = new App.Controller.Root)
    @initialUrl = location.pathname

    App.instance = @

  _loadCallback: =>
    # Only navigate to URL once loaded.
    Spine.Route.setup(history: false)

window.App = App
