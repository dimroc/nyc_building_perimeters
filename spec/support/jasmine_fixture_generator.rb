module JasmineFixtureGenerator
  def save_fixture(json, name)
    return unless ENV['GENERATE_JASMINE_FIXTURES']

    fixture_path = Rails.root.join('spec', 'javascripts', 'fixtures')
    FileUtils.mkdir_p(fixture_path)

    fixture_file = File.join(fixture_path, "#{name}.js.coffee")

    json = JSON.parse(json) if json.class == String
    File.open(fixture_file, 'w') do |file|
      file.puts(<<-TEMPLATE)
Fixtures.#{name} =
#{JSON.pretty_generate(json)}
      TEMPLATE
    end
  end
end

RSpec.configure do |config|
  config.include(JasmineFixtureGenerator)
end
