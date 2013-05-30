require 'spec_helper'

describe Ability do
  subject { Ability.new(users(:standard_user)) }
  describe "User" do
    it { should be_able_to(:manage, Block.new) }
  end
end
