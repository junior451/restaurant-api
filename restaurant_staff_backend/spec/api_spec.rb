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

  describe 'View staff information' do
    it 'returns a specific staff information based on an ID' do
      expected_booking = {
        id:1,
        name:"Joseph",
        order_delivered:3
      }

      post '/bookings', expected_booking
      get '/bookings/1'

      expect(last_response.body).to eq(expected_booking.to_json)
    end

    it 'returns a 200' do
      get '/bookings/1'

      expect(last_response.status).to eq(200)
    end
  end

  describe 'make a Booking' do
    booking = {
      id:1,
      table_size:4,
      time:'4am'
    }.to_json

    it 'stores booking info in a database' do
      post '/bookings', booking

      expect(last_response.body).to eq(booking)
    end

    it 'returns a 200' do
      post '/bookings', booking

      expect(last_response.status).to eq(200)
    end  
  end
end