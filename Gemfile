require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']

source 'https://rubygems.org'

gem 'rails', '~> 3.2.13'
gem 'pg'
gem 'jquery-rails'
gem "haml", ">= 3.1.6"
gem 'hashie'
gem "sendgrid"
gem "devise", ">= 2.1.0"
gem 'omniauth-facebook', '1.4.0'
gem "cancan", ">= 1.6.7"
gem "rolify", ">= 3.1.0"
gem "simple_form"
gem "thin-rails"
gem "json2-rails"
gem "spine-rails", git: "git://github.com/spine/spine-rails.git", ref: 'c7b884484768caf1027a606f803653e8402f4b96'
gem "eco"
gem "friendly_id", "~> 4.0.9"
gem 'simple_form'

gem 'activerecord-postgis-adapter'
gem 'rgeo'
gem 'rgeo-shapefile'
gem 'rgeo-geojson'
gem 'georuby'
gem 'rbpoly2tri'

gem 'panda', git: 'git://github.com/pandastream/panda_gem.git'
gem 'pusher'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem "twitter-bootstrap-rails"
  gem 'less-rails'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem "guard", ">= 0.6.2"
  gem "guard-livereload", ">= 0.3.0"
  gem "guard-coffeescript"
  gem "guard-ctags-bundler"
  gem "guard-rails", git: "git://github.com/johnbintz/guard-rails.git"

  gem "pry"
  gem "pry-debugger"

  gem "fuubar"
  gem "ffaker"
  gem "awesome_print"
  gem "haml-rails", ">= 0.3.4"
  gem "rspec-rails", ">= 2.10.1"
  gem "capybara"
  gem "capybara-firebug"
  gem "shoulda-matchers"
  gem "factory_girl_rails", ">= 3.3.0"
  gem "fixture_builder"
  gem "email_spec", ">= 1.2.1"
  gem "jasminerice"

  gem 'vcr'
  gem 'webmock', require: false

  case HOST_OS
    when /darwin/i
      gem 'rb-fsevent', :group => [:development, :test]
      gem 'growl', :group => [:development, :test]
    when /linux/i
      gem 'libnotify', :group => [:development, :test]
      gem 'rb-inotify', :group => [:development, :test]
    when /mswin|windows/i
      gem 'rb-fchange', :group => [:development, :test]
      gem 'win32console', :group => [:development, :test]
      gem 'rb-notifu', :group => [:development, :test]
  end
end
