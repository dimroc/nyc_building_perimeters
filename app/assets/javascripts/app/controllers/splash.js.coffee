class App.Controller.Splash extends Spine.Controller
  className: 'splash'

  constructor: ->
    super
    @render()

  render: =>
    if !Env.isChrome23
      @html @view('splash/browserError')(regionNames: Constants.region_names)
    else
      @html @view('splash/index')(regionNames: Constants.region_names)
      App.PreloadingService.preload().done(@_loadCallback)

  activate: ->
    @el.fadeIn(=> @el.addClass("active"))
    @

  deactivate: ->
    @el.empty()

  _loadCallback: =>
    @navigate '/neighborhoods' if location.pathname == "/"
