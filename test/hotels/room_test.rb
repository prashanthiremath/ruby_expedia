require "minitest_helper"

describe Suitcase::Hotel::Room do
  before :each do
    @room = Suitcase::Hotel.find(id: 123904).rooms(arrival: Keys::RESERVATION_START_TIME, departure: Keys::RESERVATION_END_TIME).first
  end

  %w(arrival departure rate_code room_type_code supplier_type tax_rate
  non_refundable occupancy quoted_occupancy min_guest_age total surcharge_total
  average_base_rate average_base_rate average_rate max_nightly_rate
  currency_code value_adds room_type_description price_breakdown total_price
  average_nightly_rate promo promo_description rate_key hotel_id
  supplier_type bed_types rooms).each do |attribute|
    it "has an attr_accessor for #{attribute}" do
      @room.must_respond_to attribute.to_sym
      @room.must_respond_to (attribute + "=").to_sym
    end
  end

  describe "#reserve!" do
    before :each do
      @info = { email: Keys::SENDING_EMAIL,
                first_name: "Walter",
                last_name: "Nelson",
                home_phone: "3831039402",
                payment_option: Keys::SUITCASE_PAYMENT_OPTION, # Visa
                credit_card_number: Keys::CREDIT_CARD_NUMBER_TESTING,
                credit_card_verification_code: Keys::CREDIT_CARD_CVV_TESTING, # CVV
                credit_card_expiration_date: Keys::CREDIT_CARD_EXPIRATION_DATE_TESTING,
                address1: "travelnow", # for testing
                address2: "Apt. 4A",
                city: "Boston",
                province: "MA",
                country: "US",
                postal_code: "02111" }
      @room.rooms = [{}]
      @room.rooms[0][:adults] = 1
      @room.rooms[0][:children_ages] = [5, 3]
      # @room.rooms[0][:bed_type] = @room.bed_types[0]
      @room.rooms[0][:smoking_preference] = "NS"
    end

    it "returns a Suitcase::Reservation" do
      reservation = @room.reserve!(@info)
      reservation.must_be_kind_of(Suitcase::Hotel::Reservation)
    end

    it "raises errors on invalid info" do
      lambda { @room.reserve!(@info.merge(credit_card_number: "")) }.must_raise Suitcase::Hotel::EANException
    end
  end
end

