require 'spec_helper'

describe THREEJS::Encoder do
  describe ".outlines" do
    let(:geometry) { GeometryHelper.square(0, 0, 5) }

    it "should generate a THREE JS model format hash" do
      as_json = THREEJS::Encoder.outlines geometry
      as_json.should == [[
        0.0, 0.0,
        0.0, 5.0,
        5.0, 5.0,
        5.0, 0.0,
        0.0, 0.0,
      ]]
    end
  end

  describe ".offset_outlines" do
    let(:geometry) { GeometryHelper.square(10, 10, 10) }
    let(:outlines) { THREEJS::Encoder.outlines(geometry) }

    it "should generate a THREE JS model format hash" do
      as_json = THREEJS::Encoder.offset_outlines outlines, {x:-10,y:-10}, 0.5
      as_json.should == [[
        0.0, 0.0,
        0.0, 5.0,
        5.0, 5.0,
        5.0, 0.0,
        0.0, 0.0,
      ]]
    end
  end

  describe ".model_from_geometry" do
    context "integration with nyc's simplified geometry" do
      let(:geometry) do
        region = worlds(:nyc).regions.find_by_name("Manhattan")
        region.simplify_geometry
      end

      context "when the first and last point are identical" do
        it "should generate a THREE JS model format hash" do
          as_json = THREEJS::Encoder.model_from_geometry geometry
          as_json[:vertices].count.should > 0
          as_json[:faces].count.should > 0
          to_json = as_json.to_json
        end
      end
    end

    context "square" do
      let(:geometry) { GeometryHelper.square }

      it "should generate a THREE JS model format hash" do
        as_json = THREEJS::Encoder.model_from_geometry geometry
        as_json[:vertices].count.should == 6 * 3 # 6 3D points
        as_json[:faces].should == [
          0, 0, 1, 2, # First triangle face
          0, 3, 4, 5  # Second triangle face
        ]
      end
    end

    context "multipolygon" do
      let(:multipolygon) do
        factory = Mercator::FACTORY.projection_factory

        left = width = 5
        bottom = height = 10

        linear_ring = factory.linear_ring([
          factory.point(left, bottom),
          factory.point(left, bottom + height),
          factory.point(left + width, bottom + height),
          factory.point(left + width, bottom)])

        geometry1 = factory.polygon(linear_ring)

        left = width = 15
        bottom = height = 2

        linear_ring = factory.linear_ring([
          factory.point(left, bottom),
          factory.point(left, bottom + height),
          factory.point(left + width, bottom + height),
          factory.point(left + width, bottom)])

        geometry2 = factory.polygon(linear_ring)
        factory.multi_polygon([geometry1, geometry2])
      end

      it "should generate triangles for both polygons" do
        as_json = THREEJS::Encoder.model_from_geometry multipolygon
        as_json[:vertices].count.should == 6 * 3 * 2 # 6 3D points for 2 geometries
        as_json[:faces].should == [
          0, 0, 1, 2,
          0, 3, 4, 5,
          0, 6, 7, 8,
          0, 9, 10, 11
        ]
      end
    end
  end

  describe ".offset_model" do
    subject { THREEJS::Encoder.offset_model(model, {x: -5, y: 15 }, 1) }

    let(:model) do
      factory = Mercator::FACTORY.projection_factory

      left = 5
      bottom = -15
      width = 5
      height = 5

      linear_ring = factory.linear_ring([
        factory.point(left, bottom),
        factory.point(left, bottom + height),
        factory.point(left + width, bottom + height),
        factory.point(left + width, bottom)])

      THREEJS::Encoder.model_from_geometry factory.polygon(linear_ring)
    end

    it "should remove all the padding from the vertices such that 0,0 is the top left most vertex" do
      vertices = subject[:vertices]
      vertices.should == [
        0, 5.0, 0,
        5.0, 0, 0,
        5.0, 5.0, 0,
        0, 5.0, 0,
        0, 0, 0,
        5.0, 0, 0]
    end
  end
end
