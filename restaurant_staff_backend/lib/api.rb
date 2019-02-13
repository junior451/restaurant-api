require 'sinatra/base'
require 'json'
require_relative 'staff'
require 'rest-client'

#localhost:8080

module RestaurantStaff
  class API < Sinatra::Base        
    get '/' do
      'hello wd'
    end

    get '/staff/:id' do
      staff = Staff.get(params[:id])

      if staff.nil?
        halt [404, ""]
      end
      
      { 
        id:staff.id, 
        name:staff.name, 
        order_delivered:staff.order_delivered 
      }.to_json
    end

    get '/booking/:id' do
      booking = Bookings.get(params[:id])

      if booking.nil?
        halt [404, ""]
      end
      
      booking_response = {
        :name => booking.name,
        :email_address => booking.email_address,
        :phone_number => booking.phone_number,
        :table_size => booking.table_size, 
        :date => booking.date,
        :time => booking.time,
        :reservation_type => booking.reservation_type
      }.to_json
      
      RestClient.post("localhost:9292/customer_booking", {:data => booking_response}, {:content_type => :json, :accept => :json})
    end

    get '/customer/booking/:id' do
      p params[:id]
      booking = Bookings.first(params[:id])

      if booking.nil?
        halt [404, ""]
      end
      
      booking_response = {
        :name => booking.name,
        :table_size => booking.table_size, 
        :date => booking.date,
        :time => booking.time,
        :reservation_type => booking.reservation_type
      }.to_json
      
      RestClient.post("localhost:9292/booking/info", {:data => booking_response}, {:content_type => :json, :accept => :json})
    end

    get '/bookings' do
      booking_array = Bookings.all.each_with_object([]) do |booking, hash|
        booking_hash = {
          :id => booking.id,
        }.to_json
        
        hash.push(booking_hash)
      end
      RestClient.post("localhost:9292/bookings", {:data => booking_array}, {:content_type => :json, :accept => :json})
    end

    
    get '/customer/bookings/:id' do
      bookings = Bookings.all(:booking_id => params[:id])
      booking_array = bookings.each_with_object([]) do |booking, hash|
        booking_hash = {
          :id => booking.booking.id,
        }.to_json
        
        hash.push(booking_hash)
      end  

      RestClient.post("localhost:7272/customer/bookings", {:data => booking_array}, {:content_type => :json, :accept => :json})
    end
      
    get '/customers/:id' do
      id = params[:id]
			#response = RestClient.get("restaurant-api_customers_1:2000/customers/#{id}")
			response
    end

    post '/booking' do
      p params[:booking]
      Bookings.create(params[:booking])
      redirect to('/after_booking')
    end
    
    get '/after_booking' do
      RestClient.get("localhost:7272/after_booking")
    end

    post '/staff' do
      if params.empty?
        [404, "no booking information"]
      else
        Staff.create(name:params[:name], order_delivered:params[:order_delivered])
      end
    end

    delete '/booking/:id' do
      id = params[:id]
      Bookings.get(id).destroy
      RestClient.get("localhost:9292/after_delete")
    end
  end
end 