require "minitest_helper"

describe Suitcase::Hotel::Location do
  before :each do
    @location = Suitcase::Hotel::Location.new({})
  end
  
  [:destination_id, :province, :country, :country_code, :city, :type,
  :active].each do |accessor|
    it "has an accessor for #{accessor}" do
      @location.must_respond_to(accessor)
      @location.must_respond_to((accessor.to_s + "=").to_sym)
    end
  end

  describe ".find" do
    it "returns an Array of Locations" do
      locations = Suitcase::Hotel::Location.find(destination_string: "Lond")
      locations.must_be_kind_of(Array)
      locations.first.must_be_kind_of(Suitcase::Hotel::Location)
    end
  end
end