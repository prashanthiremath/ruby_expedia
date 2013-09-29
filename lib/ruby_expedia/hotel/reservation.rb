module RubyExpedia
  class Hotel
    class Reservation
      attr_accessor :itinerary_id, :confirmation_numbers, :raw, :surcharges

      # Internal: Create a new Reservation from the API response.
      #
      # info - The Hash of information returned from the API.
      def initialize(info)
        @itinerary_id, @confirmation_numbers = info[:itinerary_id], [info[:confirmation_numbers]].flatten
        @surcharges = info[:surcharges]
      end
    end
  end
end
