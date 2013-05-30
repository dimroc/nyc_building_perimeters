require 'spec_helper'

RSpec::Matchers.define :equal_json_of do |expected|
  match do |actual|
    actual.should == JSON.parse(expected.to_json)
  end
end
