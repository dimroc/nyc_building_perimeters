class Admin::PandaVideosController < AdminController
  respond_to :html

  def index
    @access_details = Panda.signed_params('POST', '/videos.json')
    @videos = Panda::Video.all
  end
end
