require 'sinatra'
require 'rest-client'

set :bind, '0.0.0.0'

get '/' do
	p 'hello'
end

# post '/booking' do
# 	p params.to_json
# end

get '/customers' do
	response = RestClient.get('http://localhost:3000/customers')
 response
end