require 'spec_helper'

describe RGeo::Cartesian::BoundingBox do
  let(:bb) do
    Cartesian::BoundingBox.create_from_points(
      Cartesian::preferred_factory().point(0,0),
      Cartesian::preferred_factory().point(9,9))
  end

  describe "#step" do
    let(:increment) { 1 }
    it "should yield a point for every step" do
      steps = []
      positions = []
      bb.step(increment) do |point, step_x, step_y|
        steps << point
        positions << [step_x, step_y]
      end

      positions.count.should == positions.uniq.count
      steps.count.should == 100
      (0..10).each do |x|
        (0..10).each do |y|
          steps.select { |s| s.x == x && s.y == y }.count == 1
        end
      end
    end
  end

  describe "#steps" do
    let (:increment) { 1 }
    it "should return the number of steps to walk the area of the bb" do
      bb.steps(increment).should == 100
    end
  end
end
