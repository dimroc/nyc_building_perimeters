require 'spec_helper'

describe Loader::Neighborhood do
  describe ".from_shapefile" do
    subject { Loader::Neighborhood.from_shapefile(shapefile) }
    context "integration" do
      let(:shapefile) { "lib/data/shapefiles/neighborhoods/region" }

      it "should load neighborhoods from manhattan" do
        subject

        Neighborhood.where(borough: "Manhattan").should_not be_empty
        Neighborhood.find_by_name("East Village").should be
      end
    end
  end
end
