class App.StatsRenderer
  constructor: ->
    return unless enabled()
    @stats = createStats()

  attachToDom: (domElement) ->
    return unless enabled()
    $(domElement).prepend(@stats.domElement)

  destroy: ->
    return unless enabled()
    $(@stats.domElement).remove()

  update: ->
    return unless enabled()
    @stats.update()

enabled = ->
  true
  # Env.development || Env.test

createStats = ->
  stats = new Stats()
  stats.setMode(0)

  stats.domElement.children[ 0 ].children[ 0 ].style.color = "#aaa"
  stats.domElement.children[ 0 ].style.background = "transparent"
  stats.domElement.children[ 0 ].children[ 1 ].style.display = "none"

  stats.domElement.children[ 1 ].children[ 0 ].style.color = "#aaa"
  stats.domElement.children[ 1 ].style.background = "transparent"
  stats.domElement.children[ 1 ].children[ 1 ].style.display = "none"

  stats
