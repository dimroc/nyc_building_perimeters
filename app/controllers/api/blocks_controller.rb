class Api::BlocksController < ApiController
  before_filter :fetch_current_point
  before_filter :verify_valid_type, only: :create
  before_filter :authenticate_admin!, only: :create

  load_resource :world

  def index
    if @current_point
      respond_with Block.near(@current_point).limit(20)
    else
      respond_with Block.all
    end
  end

  def create
    raise ActiveResource::BadRequest, "No location given" unless @current_point

    if params[:panda_video_id]
      block = Block::Video.create(point: @current_point,
                                  video: PandaVideo.find(params[:panda_video_id]),
                                  user: current_user)
    elsif params[:panda_id]
      video = PandaVideo.find_or_create_from_panda(params["panda_id"])
      block = Block::Video.create(point: @current_point,
                                  video: video,
                                  user: current_user)
    else
      block = Block::Video.create(point: @current_point, user: current_user)
    end

    render json: block.to_json
  end

  private

  def verify_valid_type
    if params[:block] && params[:block][:type]
      raise ArgumentError, "Invalid block type" unless Block::BLOCK_TYPES.include? params[:block][:type]
    end
  end
end
