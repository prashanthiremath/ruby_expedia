require "minitest_helper"

describe Suitcase::Hotel::Reservation do
  before :each do
    @reservation = Suitcase::Hotel::Reservation.new({})
  end
  
  it "has a reader for itinerary_id" do
    @reservation.must_respond_to :itinerary_id
  end
  
  it "has a reader for confirmation_numbers" do
    @reservation.must_respond_to :confirmation_numbers
  end
end
