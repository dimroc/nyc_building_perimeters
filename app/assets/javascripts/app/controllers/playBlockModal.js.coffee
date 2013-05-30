class App.Controller.PlayBlockModal extends Spine.Controller
  className: "blockPlayer"

  @instance: ->
    singleton

  constructor: (block) ->
    super
    App.ModalElementService.configure(@el)

  render: (block) ->
    if block.video.url
      @html @view("playBlockModal")(block)
    else
      @html @view("noPlayBlockModal")(block)

  play: (block) ->
    @render(block)
    @$el.
      modal('show').
      on('hidden', @_stopPlaying).
      css(
       'width': -> '660px'
       'height': -> '600px'
       'margin-left': -> return -($(this).width() / 2))

  _stopPlaying: (evt) =>
    @$("video").each(-> @pause())

singleton = new App.Controller.PlayBlockModal()

