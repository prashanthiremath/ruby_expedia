module RubyExpedia
  def self.configure(&block)
    block.call(Configuration)
  end

  class Configuration
    class << self
      attr_accessor :hotel_api_key, :hotel_cid, :hotel_shared_secret,
                    :hotwire_api_key, :hotwire_linkshare_id

      attr_reader :cache

      def cache=(mechanism)
        @cache = RubyExpedia::Hotel::Cache.new(mechanism)
      end

      def method_missing(method, *args, &blk)
        if method.to_s =~ /(.+)\?/
          send($1.to_sym)
        end
      end
    end
  end
end
