require 'dm-core'
require 'dm-migrations'
require 'sinatra'

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :test do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.db")
end

class Customers
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :booked_table?, Boolean
end

DataMapper.finalize
DataMapper.auto_upgrade!