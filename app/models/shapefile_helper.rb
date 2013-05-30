require 'geo_ruby'
require 'geo_ruby/shp'

class ShapefileHelper
  extend GeoRuby::SimpleFeatures
  extend GeoRuby::Shp4r

  class << self
    def generate_rectangle(shapefile="tmp/generated_shapefile", width = 9, height = 9)
      shpfile = ShpFile.create(shapefile,
                               ShpType::POLYGON,
                               [Dbf::Field.new("name","C",10)])

      shpfile.transaction do |tr|
        polygon = Polygon.from_coordinates([[[0,0],[0,height],[width,height],[width,0]]])
        tr.add(ShpRecord.new(polygon, "name" => "Generated Square"))
      end

      shpfile.close
    end
  end
end
