require 'spec_helper'

describe Permission::Standard do
  subject { Permission::Standard.new(ability) }
  let(:ability) { Ability.new(users(:standard_user)) }
  it { should be_able_to(:manage, Block.new) }
end
