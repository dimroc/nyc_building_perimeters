if World.count == 0
  puts "No worlds found, loading in config/worlds.yml"
  Loader::World.from_yml!("config/worlds.yml")
end

Loader::World.write_json
