require 'spec_helper'

describe PusherService do
  describe ".initialized?" do
    subject { PusherService.initialized? }
    context "with credentials" do
      # Class var assignments live past the test, so clean up.
      before { Pusher.app_id = Pusher.secret = Pusher.key = 'garbage' }
      after { Pusher.app_id = Pusher.secret = Pusher.key = nil }
      it { should be_true }
    end

    context "without credentials" do
      it { should be_false }
    end
  end

  describe ".push_block" do
    before { PusherService.stub(:initialized?).and_return(initialized) }

    context "with Pusher initialized" do
      let(:initialized) { true }

      it "should broadcast a pusher event" do
        block = stub_model(Block, as_json: "hello")
        Pusher.should_receive(:trigger).with(
          'global',
          'block',
          block.as_json)

        PusherService.push_block block
      end
    end

    context "with Pusher NOT initialized" do
      let(:initialized) { false }

      it "should NOT broadcast a pusher event" do
        block = stub_model(Block)
        Pusher.should_not_receive(:trigger)
        PusherService.push_block block
      end
    end
  end
end
