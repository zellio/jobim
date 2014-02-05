require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'jobim'

require 'fakefs/spec_helpers'
require 'rack/test'

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers, fakefs: true
  config.include Rack::Test::Methods, rack_test: true
end
