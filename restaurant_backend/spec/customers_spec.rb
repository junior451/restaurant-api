require 'spec_helper'

describe 'Customers' do
  let(:app) { RestaurantCustomers::API.new }

  describe 'Homepage' do
    it 'returns homepage' do
      get '/' do
        expect(last_response.body).to eq "hello world"
        expect(last_response.status).to eq(200)
      end
    end
  end

  describe 'get /customers/:id' do
    let(:customer_info) { { id:1, name:"jacob", booked_table:false } }

    it 'returns customers info based on the id' do
      post '/customers', customer_info

       get '/customers/id'
       expect(last_response.body).to eq(customer_info.to_json)
    end
  end
end