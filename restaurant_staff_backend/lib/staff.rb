require 'dm-core'
require 'dm-migrations'
require 'sinatra'

configure :development do
  DataMapper.setup(:default, ENV['DATABASE_URL'] ||  "sqlite3://#{Dir.pwd}/development.db")
end

configure :test do
  DataMapper.setup(:default, ENV['DATABASE_URL'] ||  "sqlite3://#{Dir.pwd}/test.db")
end

class Staff
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :order_delivered, Integer
end

DataMapper.finalize
DataMapper.auto_upgrade!