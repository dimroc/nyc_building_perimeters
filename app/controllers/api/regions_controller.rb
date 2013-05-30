class Api::RegionsController < ApiController
  before_filter :fetch_current_point
  load_resource :world

  def index
    as_json = @world.regions.as_json
    set_current_region(as_json)

    respond_with(as_json)
  end

  private

  def set_current_region(as_json)
    return unless @current_point

    current_region = @world.regions.detect { |region| region.contains? @current_point }
    current_region_hash = as_json.detect { |entry| entry["id"] == current_region.id }
    current_region_hash.merge!("current" => true) if current_region
  end
end
