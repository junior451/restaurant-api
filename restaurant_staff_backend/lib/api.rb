require 'sinatra/base'
require 'json'
require_relative 'staff'

module RestaurantStaff
  class API < Sinatra::Base    
    get '/' do
      'hello world'
    end

    get '/bookings/:id' do
      staff = Staff.get(params[:id])
      
      { 
        id:staff.id, 
        name:staff.name, 
        order_delivered:staff.order_delivered 
      }.to_json

    end

    post '/bookings' do
      Staff.create(name:params[:name], order_delivered:params[:order_delivered])
      request.body.read
    end
  end
end