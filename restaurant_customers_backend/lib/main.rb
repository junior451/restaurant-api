require 'sinatra/base'
require_relative 'customers'
require 'json'
require 'rest-client'
require 'sinatra'
require 'sinatra/cookies'

#localhost:8888'

module RestaurantCustomersBackend
  class API < Sinatra::Base
    get '/' do
      'working'
    end
    
    post '/login' do
      customer = Customers.first(:username => params[:username], :password => params[:password])

      customer_info = {
        :name => customer.name,
        :username => customer.username,
        :booking_id => customer.booking_id
      }.to_json
  
      #RestClient.post("localhost:7272/customer/home", {:data => customer_info}, {:content_type => :json, :accept => :json})
    end

    post '/signup' do 
      info = params[:register_info]
      booking_id = info[:username] + info[:password]
      params[:register_info][:booking_id] = booking_id.hash.to_s

      customer = Customers.create(params[:register_info])

      customer_info = {
        name:customer.name,
        :username => customer.username,
        booking_id:customer.booking_id
      }.to_json
      
      #RestClient.post("localhost:7272/customer/home", {:data => customer_info}, {:content_type => :json, :accept => :json})
    end

    post '/booking' do
      customer = Customers.first(:booking_id => params[:booking][:booking_id])
      params[:booking][:name] = customer.name
      params[:booking][:phone_number] = customer.phone_number
      params[:booking][:email_address] = customer.email_address
      RestClient.post("localhost:8080/booking",params)
    end

    get '/customers' do
      customers_array = Customers.all.each_with_object([]) do |customer, hash|
        customer_hash = {
          :id => customer.id,
          :name => customer.name,
        }.to_json
        
        hash.push(customer_hash)
      end

      RestClient.post("localhost:9292/customers", {:data => customers_array}, {:content_type => :json, :accept => :json})
    end

    get '/customer/:id' do
      customers = Customers.all(:id => params[:id]) + Customers.all(:booking_id => params[:id])

      customers.each do |customer|
        params[:booking_id] = customer.booking_id
        params[:name] = customer.name
        params[:phone_number] = customer.phone_number
        params[:email_address] = customer.email_address
      end

      RestClient.post("localhost:8080/customer_info",params)
    end
  end
end