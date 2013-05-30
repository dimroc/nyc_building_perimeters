require 'spec_helper'

describe PusherObserver do
  before(:each) { enable_observer(:pusher_observer) }

  describe 'after block creation' do
    it "should push the block" do
      block = FactoryGirl.build(:block)
      PusherService.should_receive(:push_block).with(block)
      block.save!
    end
  end
end
