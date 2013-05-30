require 'spec_helper'

describe ZipCodeMap do
  describe ".intersects" do
    describe "with the wrong SRID" do
      it "should raise an error" do
        point = Mercator::FACTORY.point(-8225961.8649846, 4947122.3382391)
        expect {
          ZipCodeMap.intersects(point)
        }.to raise_error
      end
    end

    describe "a containing point" do
      it "should return the intersecting zip code" do
        #point = ZipCodeMap.first.point # This should work ... *sigh*
        point = Mercator::FACTORY.projection_factory.point(-8223106.86880972,4947516.28618495)
        ZipCodeMap.intersects(point).should == [ZipCodeMap.first]
      end
    end

    describe "a point lying outside" do
      it "should return no zip codes" do
        point = Mercator::FACTORY.projection_factory.point(5, 10)
        ZipCodeMap.intersects(point).should == []
      end
    end
  end
end
