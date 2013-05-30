begin
  require 'rspec/core/rake_task'

  namespace :jasmine do
    desc "Run examples that generate fixtures for use in Jasmine"
    task :generate_fixtures do
      ENV['GENERATE_JASMINE_FIXTURES'] = "true"
      Rake::Task["spec:private_jasmine_fixtures"].invoke
    end
  end

  namespace :spec do
    RSpec::Core::RakeTask.new(:private_jasmine_fixtures) do |task|
      task.pattern = "./spec/{controllers,views}/**/*_spec.rb"
      task.rspec_opts = "-t jasmine_fixture"
    end

    desc "Load spec fixtures into current environment"
    task "db:fixtures:load" do |task|
      puts "Loading spec fixtures..."
      ENV['FIXTURES_PATH'] = "spec/fixtures/"
      Rake::Task["db:fixtures:load"].invoke
    end
  end
end
