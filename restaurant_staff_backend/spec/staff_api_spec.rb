RSpec.describe 'Restaurant Staff API' do
  let(:app) { RestaurantStaff::API.new }

  describe 'Homepage' do
    it 'has a hello world text on the page' do
      get '/'
  
      expect(last_response.body).to eq('hello world')
    end

    it 'returns a 200' do
      get '/'

      expect(last_response.status).to eq(200)
    end
  end

  describe 'get /staff/:id' do
    let(:booking_info) { { id:1, name:"Joseph", order_delivered:3 } }

    context 'success' do
      it 'returns a specific staff information based on an ID' do
        post '/staff', booking_info
        get '/staff/1'
  
        expect(last_response.body).to eq(booking_info.to_json)
      end
  
      it 'returns a 200' do
        post '/staff', booking_info
        get '/staff/1'
  
        expect(last_response.status).to eq(200)
      end
    end

    context 'failure' do
      it 'returns an empty body if the staff id doesnt exist' do
        post '/staff', booking_info
        get '/staff/2'

        expect(last_response.body).to eq("")
      end

      it 'returns a 404' do
        post '/staff', booking_info
        get '/staff/2'

        expect(last_response.status).to eq(404)
      end
    end
  end

  describe 'post /staff' do
    let(:staff_info) { { name:"Junior", order_delivered:6 } }

    context 'success' do
      it 'stores booking info in a database' do
        post '/staff', staff_info
  
        expect(Staff.get(1).name).to eq(staff_info[:name])
        expect(Staff.get(1).order_delivered).to eq(staff_info[:order_delivered])
      end
  
      it 'returns a 200' do
        post '/staff', staff_info
  
        expect(last_response.status).to eq(200)
      end
    end
    
    context 'failure' do
      it 'returns error message if booking is not provided' do
        post '/staff'

        expect(last_response.body).to eq("no booking information")
      end
      
      it 'returns a 404' do
        post '/staff'

        expect(last_response.status).to eq(404)
      end
    end
  end
end