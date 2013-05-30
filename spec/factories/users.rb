FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { "secret sauce" }

    factory :admin do
      after(:create) do |user, evaluator|
        user.add_role(:admin)
      end
    end
  end
end
