require 'spec_helper'
require_relative '../../main.rb'

describe 'Customers' do
  include Rack::Test::Methods
  let(:app) {App}

  describe '/customers' do

    it 'returns a list of customers' do
       get '/customers'

      expect(last_response.body).to eq({1 => { :name => 'mason', :date => '1995-05-23T00:00:00+01:00' }, 2 => { :name => 'junior', :date => '1998-04-23T00:00:00+01:00'}}.to_json)
    end
  end
end
