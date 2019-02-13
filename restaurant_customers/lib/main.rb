require 'sinatra'
require 'rest-client'
require 'json'

#localhost:7272

# def authenticate!
# 	p session[:id]
# 	unless session[:id]
# 		redirect to('/')
# 	end
# end

module RestaurantCustomers
	class API < Sinatra::Base
		use Rack::Session::Cookie, 
		:key => 'rack.session',
		:path => '/',
		:secret => 'some_secret'

		get '/' do
			p session[:id]
			erb :home
		end

		get '/login' do
			erb :login
		end

		get '/signup' do
			erb :signup
		end

		post '/login' do
			RestClient.post("localhost:8888/login",params)
		end

		post '/after_login' do
			@customer = JSON.parse(params[:data], symbolize_names:true)
			session[:id] = @customer[:booking_id]
			erb :customers_home
		end

		get '/logout' do
			session.clear
			redirect to('/')
		end
 
		post '/signup' do
			RestClient.post("localhost:8888/signup",params)
		end

		post '/after_signup' do
			@customer = JSON.parse(params[:data], symbolize_names:true)
			session[:id] = @customer[:booking_id]
			RestClient.get("localhost:8888/customers/#{session[:id]}")
		end

		post '/customers/home' do
			@customer = JSON.parse(params[:data], symbolize_names:true)
			erb :customers_home
		end

		get '/booking_form' do
			erb :booking_form
		end

		post '/booking' do
			#RestClient.post("http://192.168.99.100:4000/booking",params)
			params[:booking][:booking_id] = "-4461116352285698967"
			RestClient.post("localhost:8888/booking",params)
		end

		get '/after_booking' do
			"Booking saved"
		end

		get '/customer/bookings' do
			RestClient.get("localhost:8080/customer/bookings/#{"-4461116352285698967"}")
		end

		post '/customer/bookings' do
			params[:data].map! do |booking|
        JSON.parse(booking, symbolize_names:true)
      end

			@bookings = params[:data]
			p @bookings
			erb :customer_bookings
		end

		get '/booking/info/:id' do
			RestClient.get("localhost:8080/customer/booking/#{params[:id]}")
		end

		post '/booking/info' do
			p params[:data]
		end
	end
end