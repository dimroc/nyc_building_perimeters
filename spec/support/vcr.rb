require 'webmock'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock # or :fakeweb
  c.ignore_localhost = true
  c.default_cassette_options.merge!({
    record: :none,
    match_requests_on: [:method, :host, :path]
  })
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end
