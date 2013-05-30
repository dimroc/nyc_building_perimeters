require 'spec_helper'

describe User do
  describe "factories" do
    it "should create a valid user" do
      FactoryGirl.build(:user).should be_valid
    end
  end
end
