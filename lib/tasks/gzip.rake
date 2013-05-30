namespace :gzip do
  desc "Gzip all pregenerated json in public/static"
  task :static => :environment do
    Gzipper.static_json
  end
end
