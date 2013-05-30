Panda.configure((ENV['PANDASTREAM_URL'] || YAML::load_file(File.join(File.dirname(__FILE__),"..", "panda.yml"))[Rails.env]))

# Only works with Heroku Addon
# Panda.configure_heroku
