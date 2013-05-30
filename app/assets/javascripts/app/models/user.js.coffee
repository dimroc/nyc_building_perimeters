class App.User extends Spine.Model
  isAdmin: =>
    _(@roles).contains("admin")

  facebookId: =>
    @uid if @provider is "facebook"

  profilePhoto: =>
    switch @provider
      when "facebook" then "https://graph.facebook.com/#{@uid}/picture"

  profilePhotoProxy: =>
    "/api/users/#{@id}/photo"

