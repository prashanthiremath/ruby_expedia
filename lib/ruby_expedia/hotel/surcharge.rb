module RubyExpedia
  class Hotel
    # Public: A Surcharge represents a single surcharge on a Room.
    class Surcharge
      attr_accessor :amount, :type
      # Internal: Create a new Surcharge.
      #
      # info - A Hash of parsed info from Surcharge.parse.
      def initialize(info)
        @amount, @type = info[:amount], info[:type]
      end

      # Internal: Parse a Surcharge from the room response.
      #
      # info - A Hash of the parsed JSON relevant to the surhcarge.
      #
      # Returns a Surcharge representing the info.
      def self.parse(info)
        new(amount: info["@amount"], type: info["@type"])
      end
    end
  end
end
