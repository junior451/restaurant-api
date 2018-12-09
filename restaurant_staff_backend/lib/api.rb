require 'sinatra/base'
require 'json'
require_relative 'staff'

module RestaurantStaff
  class API < Sinatra::Base    
    get '/' do
      'hello world'
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

    post '/staff' do
      if params.empty?
        [404, "no booking information"]
      else
        Staff.create(name:params[:name], order_delivered:params[:order_delivered])
      end
    end
  end
end