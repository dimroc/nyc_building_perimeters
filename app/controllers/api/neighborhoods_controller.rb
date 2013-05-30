class Api::NeighborhoodsController < ApiController
  before_filter :fetch_current_point

  def index
    hash = if @current_point
      Neighborhood.intersects(@current_point).first.as_json(except: :geometry)
    else
      Neighborhood.all.as_json(except: :geometry)
    end

    respond_with hash
  end

  def neighbors
    neighborhood = Neighborhood.find(params[:id])
    respond_with neighborhood.neighbors.as_json(except: :geometry)
  end
end
