class Client::BlocksController < ClientController
  before_filter :fetch_current_point

  def create
    raise StandardError, "Must have location to create block" unless @current_point
    panda_video = PandaVideo.create_from_source(params[:destinationUri])
    block = Block::Video.create(
      point: @current_point,
      direction: params[:direction],
      video: panda_video)

    cors_set_access_control_headers
    render json: block.to_json
  end

  def options
    puts "In CORS Options"
    cors_preflight_check
  end

  private

  # For all responses in this controller, return the CORS access control headers.

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.

  def cors_preflight_check
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'accept, origin, content-type, nbc_signature'
    headers['Access-Control-Max-Age'] = '1728000'
    render :text => '', :content_type => 'text/plain'
  end
end
