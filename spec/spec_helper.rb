require 'brewry'
require 'vcr'
require 'webmock'

# with VCR, there is no need to set up an api key to run tests

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost = true
  # remove to start creating cassettes
  c.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |c|
  c.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join('/').gsub(/[^\w\/]+/, '_')
    VCR.use_cassette(name) { example.call }
  end
end
