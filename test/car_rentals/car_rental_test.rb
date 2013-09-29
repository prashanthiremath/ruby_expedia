require "minitest_helper"

describe Suitcase::CarRental do
  before :each do
    info = {
      destination: "Seattle",
      start_date: "07/04/2012",
      end_date: "07/11/2012",
      pickup_time: "07:30",
      dropoff_time: "11:30"
    }
    @rentals = Suitcase::CarRental.find(info)
    @rental = @rentals.first
  end
  
  [:seating, :type_name, :type_code, :possible_features,
  :possible_models].each do |accessor|
    it "has an accessor #{accessor}" do
      @rental.must_respond_to(accessor)
      @rental.must_respond_to((accessor.to_s + "=").to_sym)
    end
  end
  
  describe ".find" do
    it "returns an Array of CarRental's" do
      @rentals.must_be_kind_of(Array)
      @rental.must_be_kind_of(Suitcase::CarRental)
    end
  end
end