describe 'Staff Backend' do
	let(:app) { RestaurantStaff::API.new }
	let(:booking_info) { {"booking"=>{"table_size"=>"4", "date"=>"2019-03-24", "time"=>"13:45", "reservation_type"=>"other", "booking_id"=>"2692053378553881226", "name"=>"AJ Tracy", "phone_number"=>"078928222333", "email_address"=>"theboy.edwards@yahoo.co.uk"} } }
		
		before do
			post '/booking', booking_info
		end

  describe 'Homepage' do
    it 'has a hello world text on the page' do
      get '/'
  
      expect(last_response.body).to eq('app running on test_host')
    end

    it 'returns a 200' do
      get '/'

      expect(last_response.status).to eq(200)
    end
	end
	
	describe 'Login' do
		before do
			Staff.create(:name=>"John Edmons", :username=>"staff099", :password=>"6678", :staff_number=>"p0031" )
		end

		let(:login_info) { {"username"=>"staff099", "password"=>"6678"} }

		it 'returns information about the Staff that logged in' do
			post '/login', login_info

			hash_reponse = JSON.parse(last_response.body)
			expect(hash_reponse).to include("name" => "John Edmons","staff_number" => "p0031")
		end

		it 'returns a 200' do
      get '/'

      expect(last_response.status).to eq(200)
    end
	end

	describe 'post Booking' do
		let(:another_booking) { {"booking"=>{"table_size"=>"3", "date"=>"2019-03-24", "time"=>"12:20", "reservation_type"=>"nightlife", "booking_id"=>"2692053378553881226", "name"=>"AJ Tracy", "phone_number"=>"078928222333", "email_address"=>"theboy.edwards@yahoo.co.uk"} } }
		
		it 'creates a new booking with for a particular customer' do

			post '/booking', another_booking
			expect(
				Bookings.get(2).attributes).to include(:id=>2, :table_size=>3, :date=>"2019-03-24", :time=>"12:20", 
				:reservation_type=>"nightlife", :booking_id=>"2692053378553881226", :name=>"AJ Tracy", :phone_number=>"078928222333",
				 :email_address=>"theboy.edwards@yahoo.co.uk"
				 )
		end

		it 'returns a 200' do
      get '/'

      expect(last_response.status).to eq(200)
    end
	end

	describe 'update Booking' do
		let(:initial_booking) { {"booking"=>{"table_size"=>"3", "date"=>"2019-03-24", "time"=>"12:20", "reservation_type"=>"nightlife", "booking_id"=>"2692053378553881226", "name"=>"AJ Tracy", "phone_number"=>"078928222333", "email_address"=>"theboy.edwards@yahoo.co.uk"} } }
		let(:booking_info_update) { {"booking"=>{"table_size"=>"5", "date"=>"2019-03-16", "time"=>"20:00"} } }
		
		before do
			post '/booking', initial_booking
		end

		it 'updates the booking with the new information' do
			put '/booking/edit/1', booking_info_update

			expect(Bookings.get(2).attributes).to include(
				{:id=>2, :table_size=>3, :date=>"2019-03-24", :time=>"12:20", 
					:reservation_type=>"nightlife", :booking_id=>"2692053378553881226", :name=>"AJ Tracy", 
					:phone_number=>"078928222333", :email_address=>"theboy.edwards@yahoo.co.uk"}
			)
		end

		it 'returns a 200' do
      get '/'

      expect(last_response.status).to eq(200)
    end
	end

	describe 'get Booking' do
		it 'returns a specfic booking info' do

			get '/booking/1'

			hash_reponse = JSON.parse(last_response.body)

			expect(hash_reponse).to include("name"=>"AJ Tracy", "email_address"=>"theboy.edwards@yahoo.co.uk", 
				"phone_number"=>"078928222333", "table_size"=>4, "date"=>"2019-03-24", 
				"time"=>"13:45", "reservation_type"=>"other")
		end

		it 'returns a 200' do
      get '/'

      expect(last_response.status).to eq(200)
    end
	end

	describe 'delete Booking' do
		let(:booking_info) { {"booking"=>{"table_size"=>"3", "date"=>"2019-03-24", "time"=>"12:20", "reservation_type"=>"nightlife", "booking_id"=>"2692053378553881226", "name"=>"AJ Tracy", "phone_number"=>"078928222333", "email_address"=>"theboy.edwards@yahoo.co.uk"} } }
		before do
			post '/booking', booking_info
		end

		it 'deletes te specified booking from the DB' do
			delete '/booking/2'
			expect(Bookings.get(2)).to be_nil
		end
		
		it 'returns a 200' do
			get '/'

			expect(last_response.status).to eq(200)
		end
	end

	describe 'customer info' do
		let(:info_from_customer_db) { {"id"=>"1", "booking_id"=>"2692053378553881226", "name"=>"AJ Tracy", "phone_number"=>"078928222333", "email_address"=>"theboy.edwards@yahoo.co.uk"} }
		
		it 'returns specfic information about a customer' do
			post '/customer_info', info_from_customer_db

			hash_reponse = JSON.parse(last_response.body)
			expect(hash_reponse).to include("name"=>"AJ Tracy", "phone_number"=>"078928222333", 
				"email_address"=>"theboy.edwards@yahoo.co.uk", "number_bookings"=>1)
		end

		it 'returns a 200' do
      get '/'

      expect(last_response.status).to eq(200)
    end
	end
end