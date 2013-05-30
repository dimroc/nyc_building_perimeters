class window.Logger
  @debug: ->
    singleton.debug.apply singleton, arguments

  constructor: ->
    @enabled = Env.debug

  debug: ->
    return unless @enabled
    console.log.apply console, arguments

singleton = new Logger()
