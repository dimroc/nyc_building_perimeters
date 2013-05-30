class GeometryHelper
  class << self
    def square(left=0, bottom=0, length=5)
      rectangle(left, bottom, length, length)
    end

    def rectangle(left, bottom, width, height)
      factory = Mercator::FACTORY.projection_factory

      linear_ring = factory.linear_ring([
        factory.point(left, bottom),
        factory.point(left, bottom + height),
        factory.point(left + width, bottom + height),
        factory.point(left + width, bottom)])

      factory.polygon(linear_ring)
    end
  end
end
