namespace :world do
  def disable_logging
    @old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
  end

  def enable_logging
    raise ArgumentError, "must have disabled logging first" unless @old_logger
    ActiveRecord::Base.logger = @old_logger
  end

  desc "Generate all worlds or a specific world from worlds.yml"
  task :generate, [:name] => :environment do |t, args|
    disable_logging
    name = args[:name]

    if name
      Loader::World.from_yml!("config/worlds.yml", name)
    else
      Loader::World.from_yml!("config/worlds.yml")
    end
  end

  namespace :generate do
    desc "Generate blocks that represent USA (Contiguous states)"
    task :usa => :environment do
      puts "Creating USA (contiguous states)..."
      World.find_by_slug("usa").try(:destroy)

      Loader::World.generate({
        name: "USA",
        region_name_key: "NAME",
        inverse_scale: 250_000,
        tolerance: 500
      }).save!
    end
  end

  desc "Destroy all worlds or a specific world"
  task :destroy, [:name] => :environment do |t, args|
    name = args[:name]

    if name
      world = World.where("name ILIKE #{name}").first
      FileUtils.rm_rf ["public/static/#{world.slug}/"]
      world.destroy
    else
      World.destroy_all
      FileUtils.rm_rf ["public/static/"]
    end
  end
end
