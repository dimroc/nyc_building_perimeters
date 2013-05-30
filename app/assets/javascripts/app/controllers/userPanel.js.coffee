class App.Controller.UserPanel extends Spine.Controller
  el: ".userPanel"

  constructor: ->
    super
    @render()
    @selectedNeighborhoodController = new App.Controller.SelectedNeighborhood()

  render: ->
    @html(@view('userPanel'))
