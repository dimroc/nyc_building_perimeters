class App.Controller.AddBlockModal extends Spine.Controller
  constructor: (domElement, worldRenderer) ->
    super
    @controls = worldRenderer.controls
    @world = worldRenderer.world

    $(domElement).prepend @view("addBlockModal")
    $(domElement).dblclick(@activate)

  render: ->
    $.ajax(method: 'get', url: '/partials/block_video_form').
      success((data) =>
        $('#addBlockModal').html(data)
        @updateLocation()
      )

  updateLocation: ->
    # TODO: Decouple AddBlockModal from worldRenderer by substituting
    # in events with relevant info
    lonlat = @controls.mouseToLonLat(@world)
    if lonlat?
      $("#addBlockModal input[name=longitude]").val(lonlat.lon)
      $("#addBlockModal input[name=latitude]").val(lonlat.lat)
    else
      $("#addBlockModal input[name=longitude]").val("")
      $("#addBlockModal input[name=latitude]").val("")

  activate: =>
    if (App.current_user && App.current_user.isAdmin())
      @render()
      $('#addBlockModal').modal('show')

  deactivate: ->
    $('#addBlockModal').modal('hide')
