class Socrata::Shape
  COLUMN_TYPES = %w(
    human_address
    latitude
    longitude
    machine_address
    needs_recoding
    geometry)

  COLUMN_TYPES.each { |type| attr_reader type }

  attr_reader :point

  def initialize(array)
    @human_address = array[0]
    @latitude = array[1]
    @longitude = array[2]
    @machine_address = array[3]
    @needs_recoding = array[4]

    @geometry = create_geometry array[5]["rings"]
    @point = create_point @longitude, @latitude
  end

  private

  def create_point(x, y)
    Mercator::FACTORY.point(x.to_f, y.to_f)
  end

  def create_geometry(rings)
    points = rings[0].map { |point_array| Mercator::FACTORY.point(point_array[0], point_array[1]) }
    Mercator::FACTORY.polygon(Mercator::FACTORY.linear_ring(points))
  end
end
