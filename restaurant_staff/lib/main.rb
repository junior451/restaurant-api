require 'sinatra'
require 'rest-client'
require 'sinatra/cookies'

#localhost:9292

module RestaurantStaff
  class API < Sinatra::Base
    use Rack::MethodOverride
    helpers Sinatra::Cookies

    def authenticate!
      unless cookies[:staff_number]
				redirect to('/')
			end
    end

    def create_cookie(staff)
      cookies[:staff_number] = staff[:staff_number]
      cookies[:staff_name] = staff[:name]
    end

    get '/' do
      cookies.clear
      erb :home
    end

    get '/login' do
      erb :login
    end

    post '/login' do
      response = RestClient.post("localhost:8080/login",params)
      @staff = JSON.parse(response.body, symbolize_names:true)
      create_cookie(@staff)

      erb :staff_home
    end

    get '/logout' do
			cookies.clear
			redirect to('/')
    end

    get '/staff/home' do
      authenticate!
      erb :staff_home
    end

    get '/customers' do
      authenticate!
      RestClient.get("localhost:8888/customers")
    end

    post '/customers' do
      params[:data].map! do |customer|
        JSON.parse(customer, symbolize_names:true)
      end

      @customers = params[:data]
      erb :customers_list
    end

    get '/customer/:id' do
      authenticate!
      response = RestClient.get("localhost:8888/customer/#{params[:id]}")
      @customer = JSON.parse(response.body, symbolize_names:true)

      erb :customers_info
    end

    get '/bookings' do
      authenticate!
      RestClient.get("localhost:8080/bookings")
    end

    post '/bookings' do
      params[:data].map! do |booking|
        JSON.parse(booking, symbolize_names:true)
      end

      @bookings = params[:data]

      erb :bookings_list
    end
    
    get '/booking/:id' do
      authenticate!
      response = RestClient.get("localhost:8080/booking/#{params[:id]}")
      @booking = JSON.parse(response.body, symbolize_names:true)
      
      erb :booking_info
    end

    get '/booking/edit/:id' do
      authenticate!
      response = RestClient.get("localhost:8080/booking/#{params[:id]}")
      @booking = JSON.parse(response.body, symbolize_names:true)

      erb :edit_booking
    end
    
    put '/booking/edit/:id' do
      RestClient.put("localhost:8080/booking/edit/#{params[:id]}",params)
      erb :booking_updated
		end

    delete '/booking/:id' do
      RestClient.delete("localhost:8080//booking/#{params[:id]}")

      erb :booking_deleted
    end
  end
end