require_relative '../lib/api.rb'

RSpec.describe 'Restaurant Staff API' do
  include Rack::Test::Methods

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

  describe 'View a Booking' do
    it 'returns a specific booking based on an ID' do
      booking = {
        id: 1,
        table_size: 4,
        time: '4am'
      }
      
      get '/bookings/1'

      expect(last_response.body).to eq(JSON.generate(booking))
    end
  end
end