ENV['RACK_ENV'] = "test"

require 'sinatra'
require 'rack/test'
require 'json'

require_relative '../lib/main.rb'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.before(:each) { DataMapper.auto_migrate! }
end