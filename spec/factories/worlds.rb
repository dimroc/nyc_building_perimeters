FactoryGirl.define do
  factory :world do
    name { Faker::AddressUS.state }
  end

  factory :world_with_regions, parent: :world do
    after(:build) do |world, evaluator|
      world.regions << FactoryGirl.build(:region_with_geometry)
      world.regions << FactoryGirl.build(:region_with_geometry, left: 10, bottom: 10)

      Loader::World.generate_threejs(world, 1, 1)
      Loader::World.generate_bounding_boxes world
    end
  end
end
