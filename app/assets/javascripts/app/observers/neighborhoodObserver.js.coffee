class App.NeighborhoodObserver extends Spine.Module
  @extend Spine.Events

  constructor: ->
    App.Neighborhood.bind('selected', @handleSelection)

  handleSelection: (selectedNeighborhood) =>
    App.BuildingMesh.show(selectedNeighborhood)
      .done(->
        if (Env.autoNavigate)
          App.WorldRenderer.instance().controls.navigate(
            selectedNeighborhood.worldCenter())
      )

singleton = new App.NeighborhoodObserver()
