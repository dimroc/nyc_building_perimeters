class ClientController < ApiController
  before_filter :ensure_client_api_token, except: :options

  private

  def ensure_client_api_token
    raise ::CanCan::AccessDenied unless request.headers["NBC_SIGNATURE"] == 'GARBAGE'
  end
end
