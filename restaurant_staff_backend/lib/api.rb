require 'sinatra/base'
require 'json'

module RestaurantStaff
  class API < Sinatra::Base
    get '/' do
      'hello world'
    end

    get '/bookings/:id' do
      id = params[:id].to_i
      booking = {
        id: id,
        table_size: 4,
        time: '4am'
      }

      JSON.generate(booking)
    end
  end
end