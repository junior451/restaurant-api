require 'sinatra/base'
require_relative 'customers'
require 'json'

module RestaurantCustomers
  class API < Sinatra::Base
    get '/' do
      "hello world"
    end
  
    get '/customers/:id' do
      customer = Customers.get(1)
      
      {
        id:customer.id,
        name:customer.name,
        booked_table:customer.booked_table
      }.to_json

    end

    post '/customers' do
      if params.empty?
        [404, "no booking information"]
      else
        Customers.create(name: params[:name], booked_table: params[:booked_table])
      end
    end
  end
end