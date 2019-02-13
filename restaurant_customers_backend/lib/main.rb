require 'sinatra/base'
require_relative 'customers'
require 'json'
require 'rest-client'

#localhost:8888'

module RestaurantCustomersBackend
  class API < Sinatra::Base
    get '/' do
      "hello world"
    end
  
    get '/customers/:id' do
      customer = Customers.first(:booking_id => params[:id])
      
      if customer.nil?
        halt [404, ""]
      end

      customer_info = {
        name:customer.name
      }.to_json

      RestClient.post("localhost:7272/customers/home", {:data => customer_info}, {:content_type => :json, :accept => :json})
    end

    post '/login' do
      customer = Customers.first(:username => params[:username], :password => params[:password])

      customer_info = {
        :name => customer.name,
        :booking_id => customer.booking_id
      }.to_json

      RestClient.post("localhost:7272/after_login", {:data => customer_info}, {:content_type => :json, :accept => :json})
    end

    post '/signup' do 
      info = params[:register_info]
      booking_id = info[:username] + info[:password]
      params[:register_info][:booking_id] = booking_id.hash.to_s

      customer = Customers.create(params[:register_info])

      session_id = {
        booking_id:customer.booking_id
      }.to_json
      
      RestClient.post("localhost:7272/after_signup", {:data => session_id}, {:content_type => :json, :accept => :json})
    end

    post '/booking' do
      customer = Customers.first(:booking_id => params[:booking][:booking_id])
      params[:booking][:name] = customer.name
      params[:booking][:phone_number] = customer.phone_number
      params[:booking][:email_address] = customer.email_address
      RestClient.post("localhost:8080/booking",params)
    end
  end
end