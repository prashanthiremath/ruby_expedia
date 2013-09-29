require "minitest_helper"

describe Suitcase::Hotel::PaymentOption do
  before :each do
    @info = { currency_code: "USD" }
  end
  
  describe ".find" do
    it "returns an Array of PaymentOption's" do
      options = Suitcase::Hotel::PaymentOption.find(@info)
      options.must_be_kind_of(Array)
      options.first.must_be_kind_of(Suitcase::Hotel::PaymentOption)
    end
  end
end