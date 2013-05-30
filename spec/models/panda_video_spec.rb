require 'spec_helper'

describe PandaVideo do
  use_vcr_cassette

  describe "validations" do
    it { should validate_uniqueness_of :panda_id }
  end

  describe "scopes" do
    describe ".encoded" do
      subject { PandaVideo.encoded }
      let(:included_video) { FactoryGirl.create(:panda_video, url: "something") }

      before do
        PandaVideo.destroy_all
        FactoryGirl.create(:panda_video, url: nil)
      end

      it { should == [included_video] }
    end

    describe ".find_or_create_from_panda" do
      subject { PandaVideo.find_or_create_from_panda("81292d1d14b508c23ae93dc98ccee543") }

      it "should create a video with proper attributes" do
        subject.attributes.should include({
          "panda_id"=>"81292d1d14b508c23ae93dc98ccee543",
          "encoding_id"=>"0e4a9657c751e95cd6acfe2e89fd4d2b",
          "original_filename"=>"SanDiegoArrival.mp4",
          "width"=>640,
          "height"=>480,
          "duration"=>7405,
          "screenshot"=>"http://newblockcity.s3.amazonaws.com/0e4a9657c751e95cd6acfe2e89fd4d2b_1.jpg",
          "url"=>"http://newblockcity.s3.amazonaws.com/0e4a9657c751e95cd6acfe2e89fd4d2b.mp4"
        })
      end
    end
  end

  describe "destroy_dangling_panda_entries!" do
    subject { PandaVideo.destroy_dangling_panda_entries! }
    let!(:included_video1) { FactoryGirl.create(:panda_video, panda_id: '81292d1d14b508c23ae93dc98ccee543') }
    let!(:included_video2) { FactoryGirl.create(:panda_video, panda_id: '01d941dfed42f737421ba735c5d0a654') }
    let!(:excluded_video) { FactoryGirl.create(:panda_video, panda_id: 'gibberish') }

    it "should remove videos that do not have a corresponding panda video" do
      subject.should == [excluded_video]
      PandaVideo.exists?(included_video1.id).should be_true
      PandaVideo.exists?(included_video2.id).should be_true
      PandaVideo.exists?(excluded_video.id).should be_false
    end
  end

  describe "#refresh_from_panda!" do
    subject { video.refresh_from_panda! }
    let(:video) do
      FactoryGirl.create(:panda_video,
                         panda_id: '349c31e332c304f1c24086a56982dc91',
                         screenshot: nil,
                         url: nil)
    end

    it "should update the url and screenshot" do
      subject
      video.screenshot.should_not be_nil
      video.url.should_not be_nil
    end
  end

  describe "#exists_in_panda?" do
    subject { video.exists_in_panda? }

    context "exists" do
      let(:video) { FactoryGirl.create(:panda_video, panda_id: '81292d1d14b508c23ae93dc98ccee543') }
      it { should be_true }
    end

    context "does not exist" do
      let(:video) { FactoryGirl.create(:panda_video, panda_id: 'gibberishdoesnotexist') }
      it { should == false }
    end

    context "cannot connect to Panda" do
      let(:video) { FactoryGirl.create(:panda_video, panda_id: '81292d1d14b508c23ae93dc98ccee543') }
      before { Panda::Video.should_receive(:find).and_raise(Panda::APIError.new("gibberish")) }
      it { should == nil }
    end
  end
end
