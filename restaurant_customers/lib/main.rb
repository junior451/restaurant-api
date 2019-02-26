require 'sinatra'
require 'sinatra/cookies'
require 'sinatra/config_file'
require 'rest-client'
require 'json'

#localhost:7272

module RestaurantCustomers
	class API < Sinatra::Base
		use Rack::MethodOverride
		helpers Sinatra::Cookies
		register Sinatra::ConfigFile
		
		config_file '../config.yml'

		def authenticate!
			unless cookies[:username]
				redirect to('/')
			end
		end

		def create_cookie(customer)
			cookies[:name] = customer[:name]
			cookies[:booking_id] = customer[:booking_id]
			cookies[:username] = customer[:username]
		end

		get '/' do
			cookies.clear
			p settings.address
			erb :home
		end

		get '/login' do
			erb :login
		end

		get '/signup' do
      erb :signup
		end

		post '/login' do
			response = RestClient.post("#{settings.address}:8888/login",params)
			@customer = JSON.parse(response.body, symbolize_names:true)
			create_cookie(@customer)

			erb :customers_home
		end

		get '/logout' do
			cookies.clear
			redirect to('/')
		end
 
		post '/signup' do
			response = RestClient.post("#{settings.address}:8888/signup",params)
			@customer = JSON.parse(response.body, symbolize_names:true)
			create_cookie(@customer)

			erb :customers_home
		end

		get '/customer/home' do
			authenticate!
			erb :customers_home
		end

		get '/booking_form' do
			authenticate!
			erb :booking_form
		end

		post '/booking' do
			params[:booking][:booking_id] = cookies[:booking_id]
			RestClient.post("#{settings.address}:8888/booking",params)
		end

		get '/after_booking' do
			erb :after_booking
		end

		get '/customer_bookings' do
			authenticate!
			RestClient.get("#{settings.address}:8080/customer/bookings/#{cookies[:booking_id]}")
		end

		post '/customer_bookings' do
			params[:data].map! do |booking|
        JSON.parse(booking, symbolize_names:true)
      end

			@bookings = params[:data]
			erb :customer_bookings
		end

		get '/booking/info/:id' do
			authenticate!
			response =RestClient.get("#{settings.address}:8080/booking/#{params[:id]}")
			@booking = JSON.parse(response.body, symbolize_names:true)
			erb :booking_info
		end

		get '/no_bookings' do
      erb :no_bookings
		end

		get '/customer_info' do
			authenticate!
			response = RestClient.get("#{settings.address}:8888/customer/#{cookies[:booking_id]}")
			@customer = JSON.parse(response.body, symbolize_names:true)
			erb :profile_info
		end
	end
end