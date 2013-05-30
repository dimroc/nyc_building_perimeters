require 'spec_helper'

describe Neighborhood do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :borough }
    it { should validate_presence_of :geometry }
  end
end
