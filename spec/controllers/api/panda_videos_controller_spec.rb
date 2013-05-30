require 'spec_helper'

describe Api::PandaVideosController do
  use_vcr_cassette

  describe "#create" do
    let(:params) do
      { "panda_video_id" => "81292d1d14b508c23ae93dc98ccee543" }
    end

    it "should create a video entry" do
      expect {
        post :create, params
      }.to change { PandaVideo.count }.by(1)

      video = PandaVideo.last
      video.panda_id.should == "81292d1d14b508c23ae93dc98ccee543"
      video.url.should be
      video.screenshot.should be
    end
  end

  describe "#callback" do
    context "for a video that doesn't exist" do
      let(:params) do
        {"video_id"=>"gibberish",
         "encoding_ids"=>{"0"=>"443f1158b3f9d9a13d0ed391d726b8f7"},
         "event"=>"video-encoded",
         "action"=>"callback",
         "controller"=>"api/videos",
         "format"=>"json"}
      end

      it "should raise not found error" do
        post :callback, params
        response.status.should == 404
      end
    end

    context "for a video that exists" do
      let(:params) do
        {"video_id"=>video.panda_id,
         "encoding_ids"=>{"0"=>"443f1158b3f9d9a13d0ed391d726b8f7"},
         "event"=>"video-encoded",
         "action"=>"callback",
         "controller"=>"api/videos",
         "format"=>"json"}
      end

      let(:video) { FactoryGirl.create(:unencoded_video, panda_id: "349c31e332c304f1c24086a56982dc91") }
      let(:block_video) { FactoryGirl.create(:block_video, video: video) }

      it "should update the video's encoding url" do
        block_video.should_not be_encoded
        PusherService.should_receive(:push_block).with(block_video)
        post :callback, params
        block_video.reload.should be_encoded
        response.status.should == 200
      end
    end
  end
end
