class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
    render :text => "You do not have access to this service", :status => :forbidden
  end

  private

  def authenticate_admin!
    raise ::CanCan::AccessDenied, "Not an admin" unless current_user && current_user.has_role?(:admin)
  end
end
