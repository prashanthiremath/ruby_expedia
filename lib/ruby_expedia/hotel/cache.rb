module RubyExpedia
  class Hotel
    class Cache
      attr_accessor :store

      def initialize(store)
        @store = store
      end

      def save_query(action, params, response)
        %w(apiKey cid customerSessionId customerIpAddress locale
        customerUserAgent).each do |param|
          params.delete(param)
        end
        params.delete("currencyCode") unless action == :paymentInfo

        string_params = keys_to_strings(params)

        @store[action] ||= {}
        @store[action] = @store[action].merge(string_params => response)
      end

      def get_query(action, params)
        string_params = keys_to_strings(params)
        @store[action] ? @store[action][string_params] : nil
      end

      def keys
        @store.keys
      end

      def cached?(action, params)
        string_params = keys_to_strings(params)
        @store[action] && @store[action][string_params]
      end

      def undefine_query(action, params)
        string_params = keys_to_strings(params)
        @store[action].delete(string_params) if @store[action]
      end

      private

      def keys_to_strings(hash)
        hash.inject({}) do |memo, (k, v)| 
          memo[k.to_s] = v
          memo
        end
      end
    end
  end
end
