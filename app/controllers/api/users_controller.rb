class Api::UsersController < ApiController
  def photo
    user = User.find(params[:id])
    image_url = "https://graph.facebook.com/#{user.uid}/picture"

    response.headers['Content-Type'] = 'image/jpeg'
    response.headers['Content-Disposition'] = 'inline'
    render :text => open(image_url, "rb").read
  end
end
