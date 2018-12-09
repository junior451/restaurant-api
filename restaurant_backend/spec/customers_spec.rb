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

    context 'success' do
      it 'returns customers info based on the id' do
        post '/customers', customer_info
        get '/customers/1'

         expect(last_response.body).to eq(customer_info.to_json)
      end

      it 'returns a 200' do
        post '/customers', customer_info
        get '/customers/1'

        expect(last_response.status).to eq(200)

      end
    end
    
    context 'failure' do
      it 'returns an empty body if the customer id doesnt exit' do
        post '/customers', customer_info
        get '/customers/2'

        expect(last_response.body).to eq("")
      end

      it 'returns a 404' do
        post '/customers', customer_info
        get '/customers/2'

        expect(last_response.status).to eq(404)
      end
    end
  end

  describe 'post /customers' do
    let(:customer_info) { { name:"jacob", booked_table:false } }

    context 'success' do
      it 'stores booking info in a database' do
        post '/customers', customer_info
  
        expect(Customers.get(1).name).to eq(customer_info[:name])
        expect(Customers.get(1).booked_table).to eq(customer_info[:booked_table])
      end
  
      it 'returns a 200' do
        post '/customers', customer_info
  
        expect(last_response.status).to eq(200)
      end
    end
    
    context 'failure' do
      it 'returns error message if booking is not provided' do
        post '/customers'

        expect(last_response.body).to eq("no booking information")
      end
      
      it 'returns a 404' do
        post '/customers'

        expect(last_response.status).to eq(404)
      end
    end
  end  
end