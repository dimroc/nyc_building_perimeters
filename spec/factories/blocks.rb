FactoryGirl.define do
  factory :block do
    point { Mercator::FACTORY.point(-73, 40.72975).projection }

    factory :block_video, class: Block::Video do
      association :video, factory: :panda_video
    end
  end
end
