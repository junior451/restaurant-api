require 'spec_helper'

describe 'Customers Backend' do
	let(:app) { RestaurantCustomersBackend::API.new }
	let(:customer) { {"register_info"=>{"name"=>"Joe Cole", "phone_number"=>"07894674334", "email_address"=>"j_cole@gmail.com", "username"=>"j_cole45", "password"=>"4453"} } }

	before(:each) do
		post '/signup', customer
	end

  describe 'Homepage' do
    it 'returns the environment the app is running' do
			get '/'
			
      expect(last_response.body).to eq "app running on test_host"
		end
		
		it 'returns a 200' do
			get '/'

			expect(last_response.status).to eq(200)
		end
	end
	
	describe 'Signup' do
		let(:signup_info) { {"register_info"=>{"name"=>"Joe Gomez", "phone_number"=>"07892855534", "email_address"=>"j_gomz@gmail.com", "username"=>"j_goz34", "password"=>"2233"} } }

		it 'returns the customers infromation after sign up' do
			post '/signup', signup_info
			  hash_reponse = JSON.parse(last_response.body)
				expect(hash_reponse).to include("name" => "Joe Gomez","username" => "j_goz34")
		end

		it 'returns a 200' do
			expect(last_response.status).to eq(200)
		end
	end

	describe 'login' do
		let(:login_info) { {"username"=>"j_cole45", "password"=>"4453"} }

		it 'returns information about the customer that logged in' do
			post '/login', login_info

			hash_reponse = JSON.parse(last_response.body)
			expect(hash_reponse).to include("name" => "Joe Cole","username" => "j_cole45")
		end

		it 'returns a 200' do
			expect(last_response.status).to eq(200)
		end
	end

	describe 'View List Customers' do
		let(:another_customer) { {"register_info"=>{"name"=>"Josh King", "phone_number"=>"07894674434", "email_address"=>"j_five@yahoo.com", "username"=>"the_n_dub", "password"=>"6272"} } }
		
		it 'returns a list of customers' do
			post '/signup', another_customer
			get '/customers'

			expect(last_response.body).to include("Joe Cole", "Josh King")
		end
		
		it 'returns a 200' do
			expect(last_response.status).to eq(200)
		end
	end

	describe 'View Specific Customer info' do
		let(:customer_info) { {"name"=>"Joe Cole", "phone_number"=>"07894674334", "email_address"=>"j_cole@gmail.com", "number_bookings" => 0} }
		
		it 'returns a specific customer information' do
			get 'customer/1'

			expect(last_response.body).to eq(customer_info.to_json)
		end

		it 'returns a 200' do
			expect(last_response.status).to eq(200)
		end
	end
end