class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_or_create_for_facebook_oauth(
      request.env["omniauth.auth"],
      current_user)

    if @user.errors.present?
      render json: @user.errors, status: 400
    else
      authenticate_user!
      sign_in(:user, @user)
      render json: @user
    end
  end
end
