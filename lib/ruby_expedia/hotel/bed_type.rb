module RubyExpedia
  class Hotel
    # Public: A BedType represents a bed configuration for a Room.
    class BedType
      # Internal: The ID of the BedType.
      attr_accessor :id

      # Internal: The description of the BedType.
      attr_accessor :description

      # Internal: Create a new BedType.
      #
      # info  - A Hash from the parsed API response with the following keys:
      #         :id           - The ID of the BedType.
      #         :description  3- The description of the BedType.
      def initialize(info)
        @id, @description = info[:id], info[:description]
      end
    end
  end
end
