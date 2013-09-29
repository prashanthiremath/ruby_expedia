module RubyExpedia
  class NightlyRate
    attr_accessor :promo, :rate, :base_rate

    # Internal: Create a NightlyRate from the API response.
    #
    # info - A Hash from the API response containing nightly rate information.
    def initialize(info)
      @promo = info["@promo"]
      @rate = info["@rate"]
      @base_rate = info["@baseRate"]
    end
  end
end
