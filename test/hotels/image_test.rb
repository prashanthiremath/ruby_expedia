require "minitest_helper"

describe Suitcase::Image do
  before :each do
    @image = Suitcase::Hotel.find(id: 123904).images.first
  end
  
  [:url, :id, :caption, :height, :width, :thumbnail_url, :name].each do |meth|
    it "has an accessor for #{meth}" do
      @image.must_respond_to(meth)
      @image.must_respond_to((meth.to_s + "=").to_sym)
    end
  end
  
  describe "#url" do
    it "returns a valid URL" do
      URI.parse(@image.url).must_be_kind_of(URI)
    end
  end
end