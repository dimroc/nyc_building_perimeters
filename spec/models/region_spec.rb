require 'spec_helper'

describe Region do
  describe "factories" do
    context ".region" do
      subject { FactoryGirl.build(:region) }
      it { should be_valid }
    end

    context ".region_with_geometry" do
      subject { FactoryGirl.build(:region_with_geometry, height: 5, width: 5) }
      it { should be_valid }
    end
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :slug }
  end

  describe "#as_json" do
    subject { Hashie::Mash.new region.as_json }

    let(:region) { FactoryGirl.build(:region_with_geometry) }

    its(:geometry) { should be_nil }

    context "with threejs generated" do
      before { Loader::Region.generate_threejs(region) }

      it "should have threejs entries" do
        subject[:threejs][:model].should be
        subject[:threejs][:outlines].should == [[
          0.0, 0.0,
          0.0, 9.0,
          9.0, 9.0,
          9.0, 0.0,
          0.0, 0.0
        ]]
      end
    end
  end

  describe "#generate_bounding_box" do
    let(:region) { FactoryGirl.build(:region_with_geometry) }
    let(:expected_bb) do
      Cartesian::BoundingBox.create_from_geometry(region.geometry)
    end

    it "should generate the bounding box" do
      region.generate_bounding_box.should == expected_bb
    end
  end

  describe "#simplify_geometry" do
    let(:nyc) { worlds(:nyc) }
    let(:region) { nyc.regions.first }

    it "should have pretty much not blow up" do
      region.geometry.should be
      region.simplify_geometry.first.exterior_ring.num_points.should > 0
    end
  end
end
