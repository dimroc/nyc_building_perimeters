ActiveRecord::Base.connection.execute(<<-SQL) #postgres specific
TRUNCATE neighborhoods RESTART IDENTITY;
TRUNCATE neighborhood_neighbors RESTART IDENTITY;
SQL

Loader::Neighborhood.from_shapefile("lib/data/shapefiles/neighborhoods/region")
Loader::Neighborhood.write_building_perimeters_json
Loader::Neighborhood.write_building_perimeters_threejs
Loader::Neighborhood.populate_neighbors
Loader::Neighborhood.write_json
Loader::Neighborhood.write_neighborhoods_threejs
Loader::Neighborhood.load_neighborhood_threejs_shapes
Loader::Neighborhood.write_json(except: :geometry)
