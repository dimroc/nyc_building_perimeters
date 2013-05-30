RGeo::Cartesian::BoundingBox.class_eval do
  def step(step_increment, factory = RGeo::Geographic.simple_mercator_factory.projection_factory)
    step_x = 0
    (min_x..max_x).step(step_increment) do |x|
      step_y = 0
      (min_y..max_y).step(step_increment) do |y|
        yield factory.point(x, y), step_x, step_y
        step_y += 1
      end

      step_x += 1
    end
  end

  def steps(step_increment)
    count = 0
    step(step_increment) do
      count += 1
    end
    count
  end
end
