require 'spec_helper'

describe Api::WorldsController do
  let(:nyc) { worlds(:nyc) }

  describe ".index" do
    before { get :index }

    it "should return a list of worlds", jasmine_fixture: true do
      response.status.should == 200
      world_json = JSON.parse response.body
      world_json.count.should == World.count
      world_json[0].should equal_json_of nyc

      save_fixture(response.body, "worlds")
    end
  end
end
