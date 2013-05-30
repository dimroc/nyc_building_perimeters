namespace :neighborhood do
  desc "Generate json files for all neighborhoods"
  task :write => :environment do
    Loader::Neighborhood.populate_neighbors
    Loader::Neighborhood.write_json
    Loader::Neighborhood.write_neighborhoods_threejs
  end

  desc "Generate json files of each neighborhood's building perimeters"
  task :write_buildings => :environment do
    Loader::Neighborhood.write_building_perimeters_json
    Loader::Neighborhood.write_building_perimeters_threejs
  end
end
