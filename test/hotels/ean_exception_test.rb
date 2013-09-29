require "minitest_helper"

describe Suitcase::Hotel::EANException do
  before :each do
    @exception = Suitcase::Hotel::EANException.new(nil)
  end

  it "has an accessor recovery" do
    @exception.must_respond_to(:recovery)
    @exception.must_respond_to(:recovery=)
  end

  describe "#recoverable" do
    it "returns true if the recovery attribute is set" do
      @exception.recovery = { locations: ["London", "New London"] }
      @exception.recoverable?.must_equal(true)
    end

    it "returns false if the recovery attribute is not set" do
      @exception.recovery = nil
      @exception.recoverable?.must_equal(false)
    end
  end
end
