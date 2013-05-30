# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:panda_id) { |n| "PandaId_#{n}" }

  factory :panda_video do
    panda_id { generate(:panda_id) }
    duration 1
    width 1
    height 1
    encoding_id 1
    screenshot "MyScreenshot"
    url "MyUrl"
    original_filename "MyFilename"

    factory :unencoded_video do
      url { nil }
      screenshot { nil }
    end
  end
end
