module RubyExpedia
  class Hotel
    class Room
      attr_accessor :rate_key, :hotel_id, :supplier_type, :rate_code,
                    :room_type_code, :supplier_type, :tax_rate, :non_refundable,
                    :occupancy, :quoted_occupancy, :min_guest_age, :total,
                    :surcharge_total, :nightly_rate_total, :average_base_rate,
                    :average_rate, :max_nightly_rate, :currency_code, :value_adds,
                    :room_type_description, :price_breakdown, :total_price,
                    :average_nightly_rate, :promo, :arrival, :departure, :rooms,
                    :bed_types, :cancellation_policy, :non_refundable,
                    :guarantee_required, :deposit_required, :surcharges,
                    :rate_description, :raw, :rate_change, :guarantee_only, :room_image_url

      extend Helpers
      include Helpers

      # Internal: Create a new Room from within a Room search query.
      #
      # info  - A Hash of parsed information from the API, with any of the keys
      #         from the attr_accessor's list.
      def initialize(info)
        info.each do |k, v|
          instance_variable_set("@" + k.to_s, v)
        end
      end

      # Public: Reserve a room.
      #
      # info - A Hash of the information described on the RubyExpedia
      #       [wiki](http://github.com/thoughtfusion/suitcase/wiki/User-flow).
      #
      # Returns a RubyExpedia::Reservation.
      def reserve!(info)
        params = {}
        params["hotelId"] = @hotel_id
        params["arrivalDate"] = @arrival
        params["departureDate"] = @departure
        params["supplierType"] = @supplier_type
        # Only submit the rateKey if it is a merchant hotel
        params["rateKey"] = @rate_key if @supplier_type == "E"
        params["rateTypeCode"] = @room_type_code
        params["rateCode"] = @rate_code
        params["roomTypeCode"] = @room_type_code
        params["chargeableRate"] = chargeable_rate      
        params["email"] = info[:email]
        params["firstName"] = info[:first_name]
        params["lastName"] = info[:last_name]
        params["homePhone"] = info[:home_phone]
        params["workPhone"] = info[:work_phone] if info[:work_phone]
        params["extension"] = info[:work_phone_extension] if info[:work_phone_extension]
        params["faxPhone"] = info[:fax_phone] if info[:fax_phone]
        params["companyName"] = info[:company_name] if info[:company_name]
        if info[:additional_emails]
          params["emailIntineraryList"] = info[:additional_emails].join(",")
        end
        params["creditCardType"] = info[:payment_option].code
        params["creditCardNumber"] = info[:credit_card_number]
        params["creditCardIdentifier"] = info[:credit_card_verification_code]
        expiration_date = Date._parse(info[:credit_card_expiration_date])
        params["creditCardExpirationMonth"] = if expiration_date[:mon] < 10
                                                "0" + expiration_date[:mon].to_s
                                              else
                                                expiration_date[:mon].to_s
                                              end
        params["creditCardExpirationYear"] = expiration_date[:year].to_s
        params["address1"] = info[:address1]
        params["address2"] = info[:address2] if info[:address2]
        params["address3"] = info[:address3] if info[:address3]
        params["city"] = info[:city]
        @rooms.each_with_index do |room, index|
          index += 1
          params["room#{index}"] = "#{room[:adults].to_s},#{room[:children_ages].join(",")}"
          params["room#{index}FirstName"] = room[:first_name] || params["firstName"] # defaults to the billing
          params["room#{index}LastName"] = room[:last_name] || params["lastName"] # person's name
          params["room#{index}BedTypeId"] = room[:bed_type].id if @supplier_type == "E"
          params["room#{index}SmokingPreference"] = room[:smoking_preference] || "E"
        end
        params["stateProvinceCode"] = info[:province]
        params["countryCode"] = info[:country]
        params["postalCode"] = info[:postal_code]

        uri = Room.url(
          method: "res",
          params: params,
          include_key: true,
          include_cid: true,
          secure: true
        )
        session = Patron::Session.new
        session.timeout = 30000
        session.base_url = "https://" + uri.host
        res = session.post uri.request_uri, {}
        parsed = JSON.parse res.body

        reservation_res = parsed["HotelRoomReservationResponse"]
        handle_errors(parsed)
        surcharges = if @supplier_type == "E" && reservation_res["RateInfo"]["ChargeableRateInfo"]["Surcharges"]
          [reservation_res["RateInfo"]["ChargeableRateInfo"]["Surcharges"]["Surcharge"]].
            flatten.map { |s| Surcharge.parse(s) }
        else
          []
        end
        r = Reservation.new(
          itinerary_id: reservation_res["itineraryId"],
          confirmation_numbers: reservation_res["confirmationNumbers"],
          surcharges: surcharges 
        )
        r.raw = parsed
        r
      end

      # Public: The chargeable rate for the Hotel room.
      #
      # Returns the chargeable rate for the Room.
      def chargeable_rate
        if @supplier_type == "E"
          @total_price
        else
          @max_nightly_rate
        end
      end
      
      # Public: The description of the displayed rate.
      #
      # Returns the rate description based on the `rate_change` attribute.
      def room_rate_description
        if @rate_change
          "rate changes during the dates requested and the single nightly rate displayed is the highest nightly rate of the dates requested without taxes and fees."
        else
          "highest single night rate during the dates selected without taxes or fees"
        end
      end
    end
  end
end

