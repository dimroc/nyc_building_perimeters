require 'spec_helper'

describe Permission do
  let(:ability) { Ability.new(users(:standard_user)) }
  before do
    class MockPermission < Permission
      def grant_bogus_permissions
        can? :conquer
        can :conquer
      end
    end
  end

  it "should invoke grant_bogus_permissions and delegate can* calls to the ability" do
    ability.should_receive(:can)
    ability.should_receive(:can?)
    MockPermission.new(ability)
  end
end

