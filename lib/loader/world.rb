class Loader::World
  class << self
    def from_yml!(path, specific_world=nil)
      yaml = YAML::load(File.open(path))

      if specific_world
        configurations = yaml["worlds"].select do |config|
          config["name"].downcase == specific_world.downcase.gsub('_', ' ').gsub('-', ' ')
        end

        raise ArgumentError, "No worlds named #{specific_world}" if configurations.empty?
      else
        configurations = yaml["worlds"]
      end

      configurations.each do |config|
        name = config["name"].titleize

        puts "Generating #{name}..."
        world = generate(config)
        World.find_by_slug(name.downcase.gsub(' ','-')).try(:destroy) # Destroy old
        world.save!
        dump_to_file(world)
      end
    end

    def generate(options)
      options = OpenStruct.new options
      file_name = options.name.downcase.gsub(' ', '_')

      options.shapefile = "lib/data/shapefiles/#{file_name}/region" unless options.shapefile
      options.tolerance = 25 unless options.tolerance

      world = from_shapefile(options.name, options.shapefile, options.region_name_key)
      generate_threejs(world, 1/options.inverse_scale.to_f, options.tolerance)
      generate_bounding_boxes(world)

      world
    end

    def from_shapefile(name, shapefile, region_name_key="name")
      require 'rgeo/shapefile'

      world = World.new(name: name)
      factory = Mercator::FACTORY.projection_factory
      RGeo::Shapefile::Reader.open(shapefile, factory: factory) do |file|
        raise ArgumentError, "File contains no records" if file.num_records == 0

        file.each do |record|
          region_name = record.attributes[region_name_key.to_s] if region_name_key

          region = world.regions.build(name: region_name, geometry: record.geometry)
        end
      end

      world
    end

    def generate_threejs(world, scale, tolerance)
      bb = world.generate_bounding_box
      offset = Hashie::Mash.new(x: -bb.min_x, y: -bb.min_y, z: 0)
      world.mesh_scale = scale

      world.regions.each do |region|
        Loader::Region.generate_threejs(region, offset, scale, tolerance)
      end
    end

    def generate_bounding_boxes(world)
      world.mercator_bounding_box_geometry = world.generate_bounding_box.to_geometry
      world.mesh_bounding_box_geometry = world.generate_mesh_bounding_box.to_geometry
    end

    def write_json
      puts "Writing worlds.json"

      directory = "public/static/"
      FileUtils.mkdir_p directory
      output_file = "#{directory}worlds.json"

      File.open(output_file, "w") do |file|
        file.write World.all.to_json
      end
    end

    private

    def dump_to_file(world)
      directory = "public/static/#{world.slug}/"
      output_file = "#{directory}regions.json"

      FileUtils.mkdir_p directory
      File.open(output_file, "w") do |file|
        file.write world.regions.to_json
      end
    end

    def map_shapefile_attrs_to_region_attrs(mappings, fields)
      attributes = {}
      fields.each do |(k, v)|
        map = mappings[k]
        attributes[map] = v if map
      end
      attributes
    end
  end
end
