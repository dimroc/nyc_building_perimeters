class App.Controller.Debug extends Spine.Controller
  constructor: (domElement) ->
    super
    @domElement = domElement
    @activate()

  activate: ->
    $(@domElement).prepend(@view('debug'))
    $(".debug").fadeIn() if Env.debug
    @

  deactivate: ->
    $(".debug").remove()
