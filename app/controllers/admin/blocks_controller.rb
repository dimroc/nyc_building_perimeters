class Admin::BlocksController < AdminController
  respond_to :html

  def index
    @access_details = Panda.signed_params('POST', '/videos.json')
    @blocks = Block.all
  end
end
