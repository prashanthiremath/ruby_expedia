module RubyExpedia
  class Hotel
    class Amenity
      attr_accessor :id, :description

      BITS = { "business services" => 1,
        "fitness center" => 2,
        "hot tub" => 4,
        "internet access" => 8,
        "kids activities" => 16,
        "kitchen" => 32,
        "pets allowed" => 64,
        "swimming pool" => 128,
        "restaurant" => 256,
        "whirlpool bath" => 1024,
        "breakfast" => 2048,
        "babysitting" => 4096,
        "jacuzzi" => 8192,
        "parking" => 16384,
        "room service" => 32768,
        "accessible path" => 65536,
        "accessible bathroom" => 131072,
        "roll in shower" => 262144,
        "handicapped parking" => 524288,
        "in room accessibility" => 1048576,
        "deaf accessiblity" => 2097152,
        "braille or signage" => 4194304,
        "free airport shuttle" => 8388608,
        "indoor pool" => 16777216,
        "outdoor pool" => 33554432,
        "extended parking" => 67108864,
        "free parking" => 134217728
      }

      def initialize(info)
        @id, @description = info[:id], info[:description]
      end

      def self.parse_mask(bitmask)
        return nil unless bitmask
 
        #BITS.select { |amenity, bit| (bitmask & bit) > 0 }.keys
        I18n.t BITS.select { |amenity, bit| (bitmask & bit) > 0 }.keys
      end
    end
  end
end
