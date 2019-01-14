require 'sinatra'
require 'rest-client'

module RestaurantStaff
  class API < Sinatra::Base
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
  end
end