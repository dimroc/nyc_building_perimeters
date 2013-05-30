require 'spec_helper'

describe Client::BlocksController do
  describe ".create" do

    context "without client api token" do
      it "should not throw an error" do
        post :create, {}

        response.should be_forbidden
        response.body.should have_content "do not have access"
      end
    end

    context "with client api token" do
      before { request.env['NBC_SIGNATURE'] = 'yicceHasFatcowJemIvRurwojidfaitt' }

      it "should create a block" do
        params = {
          latitude: 40.0,
          longitude: -70.0,
          direction: 90.0,
          destinationUri: 'someUri'
        }

        PandaVideo.should_receive(:create_from_source).with('someUri').and_return(nil)
        expect {
          post :create, params
        }.to change {Block::Video.count}.by(1)

        block = Block.last
        block.direction.should == 90.0
      end
    end
  end
end
