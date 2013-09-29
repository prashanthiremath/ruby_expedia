require "minitest_helper"

describe Suitcase::Hotel::Helpers do
  before :each do
    class Dummy; extend Suitcase::Hotel::Helpers; end
  end

  describe "#url" do
    it "returns a URI with the proper base URL" do
      url = Dummy.url(method: "action", params: {})
      url.must_be_kind_of(URI)
      url.host.must_match(/api.ean.com/)
    end

    describe "when using digital signature authorization" do
      it "adds a 'sig' parameter" do
        Suitcase::Configuration.expects(:use_signature_auth?).returns(true)
        Dummy.expects(:generate_signature).returns("test")

        url = Dummy.url(method: "action", params: {})
        url.query.must_match(/sig=test/)
      end
    end
  end

  describe "#parse_response" do
    it "raises an exception when passed an invalid URI" do
      proc do
        Dummy.parse_response(URI.parse("http://google.com"))
      end.must_raise JSON::ParserError
    end

    it "raises an error if a 403 code is received" do
      proc do
        response = FakeResponse.new(code: 403, body: "<h1>An error occurred.</h1>")
        Net::HTTP.stubs(:get_response).returns(response)
        Dummy.parse_response(URI.parse("http://fake.response.will.be.used"))
      end.must_raise Suitcase::Hotel::EANException
    end
  end

  describe "#generate_signature" do
    it "returns the encrypted API key, shared secret, and timestamp" do
      Suitcase::Configuration.expects(:hotel_api_key).returns("abc")
      Suitcase::Configuration.expects(:hotel_shared_secret).returns("123")
      Time.expects(:now).returns("10")

      signature = Dummy.generate_signature
      signature.must_equal(Digest::MD5.hexdigest("abc12310"))
    end
  end

  describe "#parameterize_rooms" do
    it "returns a hash of room parameters" do
      rooms = [{adults: 1}, {adults: 2, children_ages: [3, 5]}]
      params = Dummy.parameterize_rooms(rooms)
      params.must_equal({ "room1" => "1", "room2" => "2,3,5" })
    end
  end
end
