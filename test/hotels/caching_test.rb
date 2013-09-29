require "minitest_helper"

describe Suitcase do
  before :each do
    Suitcase::Configuration.cache = {}
  end

  it "caches all non-secure queries" do
    # Query 1
    hotel = Suitcase::Hotel.find(id: 123904)
    
    # Query 2
    Suitcase::Hotel.find(location: "Boston, US")
    
    # Query 3
    room = hotel.rooms(arrival: Keys::RESERVATION_START_TIME, departure: Keys::RESERVATION_END_TIME).first
    
    # Query 4
    Suitcase::Hotel::PaymentOption.find currency_code: "USD"
    
    # Query 5, don't cache though
    room.rooms[0][:bed_type] = room.bed_types[0]
    room.rooms[0][:smoking_preference] = "NS"
    room.reserve!(Keys::VALID_RESERVATION_INFO)

    Suitcase::Configuration.cache.keys.count.must_equal 4
  end

  it "retrieves from the cache if it's there" do
    hotel = Suitcase::Hotel.find(id: 123904)
    Suitcase::Hotel.find(location: "Boston, US")
    hotel.rooms(arrival: Keys::RESERVATION_START_TIME, departure: Keys::RESERVATION_END_TIME)
    Suitcase::Hotel::PaymentOption.find currency_code: "USD"
    
    # Disable API access
    Net::HTTP.expects(:get_response).never
    hotel = Suitcase::Hotel.find(id: 123904)
    Suitcase::Hotel.find(location: "Boston, US")
    hotel.rooms(arrival: Keys::RESERVATION_START_TIME, departure: Keys::RESERVATION_END_TIME)
    Suitcase::Hotel::PaymentOption.find currency_code: "USD"
  end
end
