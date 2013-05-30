class App.Controller.Facebook extends Spine.Controller
  el: "#facebook-connect"

  events:
    'click a.login':   'login'
    'click a.logout':  'logout'

  constructor: ->
    super
    $.when(window.facebookDfd).then(@initialize)

  successfulLoginHandler: (json) =>
    App.current_user = new App.User(json)
    @html(@view('facebook/loggedIn')(App.current_user))
    console.debug "connected:", JSON.stringify(json)

  facebookSuccessHandler: (response) =>
    if(response.authResponse)
      $("#facebook-connect a.login").html("Connecting to FB...")
      $.getJSON(
        "/users/auth/facebook/callback",
        { signed_request: response.authResponse.signedRequest },
        @successfulLoginHandler)

  login: (event) ->
    FB.login(@facebookSuccessHandler, scope: "email")

  logout: (event) ->
    FB.getLoginStatus((response) =>
      if(response.status == "connected")
        FB.logout(@logoutApp)
      else
        @logoutApp()
    , true)

  logoutApp: =>
    App.current_user = null
    $.ajax(url: '/users/sign_out', type: 'DELETE')
    @_renderLoggedOut()

  _renderLoggedOut: ->
    @html(@view('facebook/loggedOut')())

  initialize: =>
    @_renderLoggedOut()

    FB.getLoginStatus((response) =>
      if response.status is "connected"
        console.debug "Automatically logging in to facebook"
        @facebookSuccessHandler response)
