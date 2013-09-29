require "minitest_helper"

describe Suitcase::Hotel::Session do
  before :each do
    @session = Suitcase::Hotel::Session.new
  end
  
  [:id, :ip_address, :user_agent, :locale, :currency_code].each do |accessor|
    it "has an accessor for #{accessor}" do
      @session.must_respond_to(accessor)
      @session.must_respond_to((accessor.to_s + "=").to_sym)
    end
  end
end
