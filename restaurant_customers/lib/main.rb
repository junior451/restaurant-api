require 'sinatra'
require 'rest-client'
require 'json'

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

		get '/customer_name' do
			'Junior'
		end

		get '/booking_form' do
			erb :booking_form
		end

		post '/booking' do
			p 'yes man'
			p params
			#RestClient.post("http://192.168.99.100:4000/booking",params)
			RestClient.post("localhost:8080/booking",params)
		end

		get '/after_booking' do
			"Booking saved"
		end
	end
end