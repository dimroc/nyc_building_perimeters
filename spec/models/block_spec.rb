require 'spec_helper'

describe Block do
  describe "callbacks" do
    it "should update the block's zip code" do
      #point = ZipCodeMap.first.point # This should work ... *sigh*
      point = Mercator::FACTORY.projection_factory.point(-8223106.86880972,4947516.28618495)

      block = Block.create(point: point)

      block.zip_code_map_id.should == ZipCodeMap.first.id
      block.zip.should == "11372"

      block.reload
      block.zip_code_map_id.should == ZipCodeMap.first.id
      block.zip.should == "11372"
    end
  end

  describe ".near" do
    subject { Block.near(near_point) }

    before { Block.delete_all }

    let(:near_point) { Mercator::FACTORY.projection_factory.point(5,5) }
    let(:far_point) { Mercator::FACTORY.projection_factory.point(25,25) }

    let!(:near_block) { Block.create(point: near_point) }
    let!(:far_block) { Block.create(point: far_point) }

    it { should == [near_block, far_block] }
  end

  describe "#as_json" do
    subject { block.as_json }
    let(:point) { Mercator::FACTORY.projection_factory.point(5,5) }
    let(:block) do
      stub_model(
        Block,
        point: point,
        zip_code_map: ZipCodeMap.first,
        neighborhood: Neighborhood.first
      )
    end

    it "should only include relevant information" do
      subject.keys.should == [
        "id",
        "recorded_at",
        :point,
        :zip_code,
        :neighborhood,
        :borough
      ]
    end

    it "should have the zip code" do
      subject[:zip_code].should == ZipCodeMap.first.zip
    end

    it "should have the neighborhood" do
      subject[:neighborhood].should == Neighborhood.first.name
    end

    it "should have the borough" do
      subject[:borough].should == Neighborhood.first.borough
    end
  end
end
