class App.Model extends Spine.Model
  appendErrors: (errorHash) ->
    _.extend(@errors, errorHash)
