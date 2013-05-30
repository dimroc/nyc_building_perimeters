class Api::WorldsController < ApiController
  def index
    respond_with(World.all)
  end
end
