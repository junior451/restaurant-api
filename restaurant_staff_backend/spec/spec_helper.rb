ENV['RACK_ENV'] = "test"

require 'sinatra'
require 'rack/test'
require 'json'

require_relative '../lib/api.rb'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

DataMapper.auto_migrate!