require 'spec_helper'

describe Block::Video do
  describe ".encoded" do
    subject { Block::Video.encoded }
    let(:encoded_video) { FactoryGirl.create(:panda_video, url: "something") }
    let(:included_block_video) { FactoryGirl.create(:block_video, video: encoded_video) }

    before do
      Block::Video.destroy_all
      unencoded_video = FactoryGirl.create(:panda_video, url: nil)
      FactoryGirl.create(:block_video, video: unencoded_video)
    end

    it { should == [included_block_video] }
  end

  describe "#as_json" do
    subject { block_video.as_json }
    let(:block_video) { FactoryGirl.create(:block_video) }

    it "should include the video details" do
      video = block_video.video
      subject.should include({ "video" =>
                               {
                                 "url" => video.url,
                                 "screenshot" => video.screenshot,
                                 "duration" => video.duration
                                }
      })
    end
  end

  describe "#encoded?" do
    subject { block_video.encoded? }
    let(:block_video) { FactoryGirl.create(:block_video, video: video) }

    context "with video" do
      let(:video) { FactoryGirl.create(:panda_video, url: url) }

      context "that is encoded" do
        let(:url) { "something" }
        it { should be_true }
      end

      context "that is not encoded" do
        let(:url) { nil }
        it { should be_false }
      end
    end

    context "without video" do
      let(:video) { nil }
      it { should be_false }
    end
  end
end
