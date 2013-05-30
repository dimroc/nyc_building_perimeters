require 'spec_helper'

describe Api::RegionsController do
  describe ".index" do
    describe "for nyc" do
      let(:world) { worlds(:nyc) }
      it "should return all regions in json" do
        get :index, world_id: world.id
        regions = JSON.parse response.body
        regions.count.should == world.regions.count
        regions.should equal_json_of world.regions
      end

      context "with long/lat coordinates" do
        let(:longitude) { -73.9846372 }
        let(:latitude) { 40.729646699999996 }

        it "should mark the region with the location", jasmine_fixture: true do
          get :index, world_id: world.id, longitude: longitude, latitude: latitude
          regions = JSON.parse response.body
          regions.detect { |region| region["current"].presence }.should be

          save_fixture(response.body, world.slug)
        end
      end
    end
  end
end
