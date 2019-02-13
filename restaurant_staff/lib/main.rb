require 'sinatra'
require 'rest-client'

#localhost:9292

module RestaurantStaff
  class API < Sinatra::Base
    use Rack::MethodOverride

    get '/' do
      'hello world staff'
    end
    
    get '/staff/:id' do
      id = params[:id]
      response = RestClient.get("restaurant-api_staff_backend_1:4000/staff/#{id}")
      response
    end

    get '/customers/:id' do
      id = params[:id]
      response = RestClient.get("restaurant-api_customer_backend_1:3000/customers/#{id}")
      response
    end
    
    get '/booking/:id' do
      id = params[:id]
      RestClient.get("localhost:8080/booking/#{id}")
    end

    get '/bookings' do
      RestClient.get("localhost:8080/bookings")
    end

    post '/customer_booking' do
      @booking = JSON.parse(params[:data], symbolize_names:true)
      erb :booking_info
    end

    post '/bookings' do
      params[:data].map! do |booking|
        JSON.parse(booking, symbolize_names:true)
      end

      @bookings = params[:data]
      erb :bookings_list
    end

    delete '/booking/:id' do
      RestClient.delete("localhost:8080//booking/#{params[:id]}")
    end

    get '/after_delete' do
      'deleted'
    end
  end
end