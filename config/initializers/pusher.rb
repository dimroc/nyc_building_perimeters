NewBlockCity::Application.configure do
  pusher_settings = YAML::load(File.open("config/pusher.yml"))[Rails.env]
  pusher_settings = OpenStruct.new pusher_settings

  Pusher.app_id = pusher_settings.app_id
  Pusher.key = pusher_settings.key
  Pusher.secret = pusher_settings.secret
end
