module RubyExpedia
  class Hotel
    class PaymentOption
      attr_accessor :code, :name

      extend Helpers

      # Internal: Create a PaymentOption.
      #
      # code - The String code from the API response (e.g. "VI").
      # name - The String name of the PaymentOption.
      def initialize(code, name)
        @code, @name = code, name
      end

      # Public: Find PaymentOptions for a specific currency.
      #
      # info - A Hash of information with one key: :currency_code.
      #
      # Returns an Array of PaymentOption's.
      def self.find(info)
        params = { "currencyCode" => info[:currency_code] }

        if Configuration.cache? and Configuration.cache.cached?(:paymentInfo, params)
          types_raw = Configuration.cache.get_query(:paymentInfo, params)
        else
          types_raw = parse_response(url(:method => "paymentInfo", :params => params, :session => info[:session]))
          Configuration.cache.save_query(:paymentInfo, params, types_raw) if Configuration.cache?      
        end
        update_session(types_raw, info[:session])

        types_raw["HotelPaymentResponse"].map do |raw|
          types = raw[0] != "PaymentType" ? [] : raw[1]
          types.map do |type|
            PaymentOption.new(type["code"], type["name"])
          end
        end.flatten
      end
    end
  end
 end
