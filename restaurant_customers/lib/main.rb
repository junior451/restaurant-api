require 'sinatra'
require 'rest-client'

module RestaurantCustomers
	class API < Sinatra::Base
		get '/' do
			p 'hello'
		end

		# post '/booking' do
		# 	p params.to_json
		# end

		get '/customers/:id' do
			id = params[:id]
			response = RestClient.get("restaurant-api_customer_backend_1:3000/customers/1")
			response
		end
	end
end