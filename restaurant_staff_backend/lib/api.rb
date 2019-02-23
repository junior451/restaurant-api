require 'sinatra/base'
require 'json'
require_relative 'staff'
require 'rest-client'

#localhost:8080

module RestaurantStaff
  class API < Sinatra::Base 

    post '/login' do
      staff = Staff.first(:username => params[:username], :password => params[:password])
      
      {
        name:staff.name,
        staff_number:staff.staff_number
      }.to_json

    end

    get '/booking/:id' do
      booking = Bookings.get(params[:id])

      if booking.nil?
        halt [404, ""]
      end
      
      booking_response = {
        :id => booking.id,
        :name => booking.name,
        :email_address => booking.email_address,
        :phone_number => booking.phone_number,
        :table_size => booking.table_size, 
        :date => booking.date,
        :time => booking.time,
        :reservation_type => booking.reservation_type
      }.to_json
    end

    put '/booking/edit/:id' do
      Bookings.get(params[:id]).update(params[:booking])
    end

    get '/bookings' do
      booking_array = Bookings.all.each_with_object([]) do |booking, hash|
        booking_hash = {
          :id => booking.id,
          :name => booking.name
        }.to_json
        
        hash.push(booking_hash)
      end
      RestClient.post("localhost:9292/bookings", {:data => booking_array}, {:content_type => :json, :accept => :json})
    end

    
    get '/customer/bookings/:id' do
      bookings = Bookings.all(:booking_id => params[:id])
      booking_array = bookings.each_with_object([]) do |booking, arr|
        booking_hash = {
          :id => booking.id
        }.to_json
        
        arr.push(booking_hash)
      end

      if booking_array.empty?
        RestClient.get("localhost:7272/no_bookings")
      else
        RestClient.post("localhost:7272/customer_bookings", {:data => booking_array}, {:content_type => :json, :accept => :json})
      end
    end

    post '/booking' do
      p params[:booking]
      Bookings.create(params[:booking])
      RestClient.get("localhost:7272/after_booking")
    end

    delete '/booking/:id' do
      id = params[:id]
      Bookings.get(id).destroy
    end

    post '/customer_info' do
      bookings = Bookings.all(:booking_id => params[:booking_id])
      params[:number_bookings] = bookings.length

      {
        :name => params[:name],
        :phone_number => params[:phone_number],
        :email_address => params[:email_address],
        :number_bookings => params[:number_bookings],
      }.to_json
    end
  end
end 