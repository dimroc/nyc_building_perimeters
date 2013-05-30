class ZipCodeMap < ActiveRecord::Base
  set_rgeo_factory_for_column(:point, Mercator::FACTORY.projection_factory)

  class << self
    def intersects(geom)
      raise ArgumentError, "Must have SRID 3785" unless geom.srid == 3785

      #ST_Intersects(zip_code_maps.geometry, ?) # Should work w/o ST_AsText
      #but might be too accurate with floating point values for testing ...?
      where(<<-SQL, geom.as_text)
        ST_Intersects(ST_AsText(zip_code_maps.geometry), ?)
      SQL
    end
  end

  def point_geographic
    Mercator.to_geographic self.point
  end
end
