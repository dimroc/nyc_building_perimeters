class Loader::Region
  class << self
    def generate_threejs(region, offset = {}, scale = 1, tolerance = 1)
      simple_geometry = region.simplify_geometry(tolerance)
      if simple_geometry
        region.threejs = THREEJS::Encoder.generate(simple_geometry, offset, scale)
      end
    end
  end
end
