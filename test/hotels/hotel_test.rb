require "minitest_helper"

describe Suitcase::Hotel do
  before :each do
    @hotel = Suitcase::Hotel.find(id: 123904)
  end

  [:id, :name, :address, :city, :amenities, :masked_amenities, :country_code,
  :high_rate, :low_rate, :longitude, :latitude, :rating, :postal_code,
  :images, :nightly_rate_total, :property_description, :number_of_floors,
  :number_of_rooms, :deep_link, :tripadvisor_rating].each do |attribute|
    it "has an attr_accessor for #{attribute}" do
      @hotel.must_respond_to(attribute)
      @hotel.must_respond_to((attribute.to_s + "=").to_sym)
    end
  end

  describe ".find" do
    it "returns a single Hotel if passed an ID" do
      @hotel.must_be_kind_of(Suitcase::Hotel)
    end

    it "returns available hotels if arrival and departure are passed in" do
      hotels = Suitcase::Hotel.find(location: "London, UK",
                                    arrival: "10/13/2013",
                                    departure: "10/15/2013",
                                    results: 1)
      hotels.must_be_kind_of(Array)
      hotels.first.must_be_kind_of(Suitcase::Hotel)
      hotels.first.raw["HotelListResponse"]["moreResultsAvailable"].must_equal(true)
    end

    it "returns multiple Hotels if a location is passed in" do
      hotels = Suitcase::Hotel.find(location: "London, UK")
      hotels.must_be_kind_of(Array)
      hotels.first.must_be_kind_of(Suitcase::Hotel)
    end
    
    it "returns multiple Hotels if a destination ID is passed in" do
      hotels = Suitcase::Hotel.find(destination_id: "58870F43-9215-4662-BAA1-CC9A20FEC4F1")
      hotels.must_be_kind_of(Array)
      hotels.first.must_be_kind_of(Suitcase::Hotel)
    end

    it "returns multiple Hotels if multiple ID's are passed in" do
      hotels = Suitcase::Hotel.find(ids: [123904, 191937, 220166])
      hotels.must_be_kind_of(Array)
      hotels.first.must_be_kind_of(Suitcase::Hotel)
    end

    it "returns an Array with a single Hotel if an Array with a single ID is passed in" do
      hotels = Suitcase::Hotel.find(ids: [123904])
      hotels.count.must_equal(1)
      hotels.first.must_be_kind_of(Suitcase::Hotel)
    end

    it "sets a recovery attribute on the raised error when the location is not specific enough" do
      begin
        Suitcase::Hotel.find(location: "Mexico")
      rescue Suitcase::Hotel::EANException => e
        e.recoverable?.must_equal(true) if e.type == :multiple_locations
      end
    end

    it "sets the error type when the location is not specific enough" do
      begin
        Suitcase::Hotel.find(location: "Mexico")
      rescue Suitcase::Hotel::EANException => e
        e.type.must_equal(:multiple_locations)
        e.recovery.must_be_kind_of(Hash)
        e.recovery[:alternate_locations].must_be_kind_of(Array)
        e.recovery[:alternate_locations].first.must_be_kind_of(Suitcase::Hotel::Location)
      end
    end
  end

  describe "#images" do
    it "correctly gets the URLs of the images" do
      images = @hotel.images
      images.must_be_kind_of(Array)
      images.map { |image| URI.parse(image.url) }
    end
  end

  describe "#thumbnail_url" do
    it "returns the first image's thumbnail URL" do
      @hotel.thumbnail_url.must_equal @hotel.images.first.thumbnail_url
    end
  end

  describe "#rooms" do
    before do
      @info = {
        arrival: "1/1/2013",
        departure: "1/8/2013"
      }
      @rooms = @hotel.rooms(@info)
    end

    it "returns an Array of available Rooms" do
      @rooms.must_be_kind_of(Array)
    end

    it "each room must contain a cancellation policy" do
      @rooms.each do |r|
        r.cancellation_policy.wont_be_nil
      end
    end

    it "each room must contain the non_refundable option" do
      @rooms.each do |r|
        r.non_refundable.wont_be_nil
      end
    end

    it "each room must contain the deposit_required" do
      @rooms.each do |r|
        r.deposit_required.wont_be_nil
      end
    end
  end
end
