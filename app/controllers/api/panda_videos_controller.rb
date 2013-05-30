class Api::PandaVideosController < ApiController
  def index
    @videos = PandaVideo.all
    respond_with @videos
  end

  def show
    respond_with PandaVideo.find(params["video_id"])
  end

  def create
    @video = PandaVideo.find_or_create_from_panda(params["panda_video_id"])
    respond_with @video, location: api_panda_videos_path
  end

  def callback
    @video = PandaVideo.find_by_panda_id(params[:video_id])
    raise ::NotFoundError unless @video

    case params[:event]
    when "video-encoded"
      @video.refresh_from_panda!
      push_encoding @video
    end

    respond_with @video, location: api_panda_video_path(@video), status: 200
  end

  private

  def push_encoding panda_video
    return unless panda_video.block_video
    PusherService.push_block panda_video.block_video
  end
end
