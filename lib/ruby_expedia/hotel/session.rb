module RubyExpedia
  class Hotel
    # Public: Hold user session data. A simple Struct provided to be passed in
    #         to some of the EAN methods.
    Session = Struct.new(:id, :user_agent, :ip_address, :locale, :currency_code)
  end
end
