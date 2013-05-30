namespace :seed do
  task :neighborhoods => :environment do
    load 'db/seeds/neighborhoods.rb'
  end
end
