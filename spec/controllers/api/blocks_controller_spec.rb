require 'spec_helper'

describe Api::BlocksController do
  use_vcr_cassette

  describe "#create" do
    let(:longitude) { -73.0 }
    let(:latitude) { 40.0 }

    context "when not an admin" do
      let(:params) do
        { "longitude" => longitude, "latitude" => latitude }
      end

      it "should be forbidden" do
        post :create, params
        response.should be_forbidden
      end
    end

    context "when an admin" do
      before { sign_in FactoryGirl.create(:admin) }

      context "without any panda/video id" do
        let(:params) do
          { "longitude" => longitude, "latitude" => latitude }
        end

        it "should create a block for that location" do
          expect {
            post :create, params
          }.to change { Block::Video.count }.by(1)

          block_hash = JSON.parse(response.body)
          Block::Video.last.video.should be_nil
        end
      end

      context "with PandaVideo id" do
        let(:video) { FactoryGirl.create(:panda_video) }
        let(:params) do
          { "longitude" => longitude, "latitude" => latitude, "panda_video_id" => video.id }
        end

        it "should create a block for that location" do
          expect {
            post :create, params
          }.to change { Block::Video.count }.by(1)

          block_hash = JSON.parse(response.body)
        end
      end

      context "with panda id (from pandastream)" do
        let(:panda_id) { "81292d1d14b508c23ae93dc98ccee543" }
        let(:params) do
          { "longitude" => longitude, "latitude" => latitude, "panda_id" => panda_id }
        end

        it "should create a PandaVideo" do
          expect {
            post :create, params
          }.to change { PandaVideo.count }.by(1)

          PandaVideo.last.panda_id.should == panda_id
        end

        it "should create a Block::Video with the new PandaVideo" do
          expect {
            post :create, params
          }.to change { Block::Video.count }.by(1)

          block = Block::Video.last
          block.video.panda_id.should == panda_id
          block.point_geographic.x.round(2).should == longitude.round(2)
          block.point_geographic.y.round(2).should == latitude.round(2)
        end
      end
    end
  end
end
