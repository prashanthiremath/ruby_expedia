# Suitcase::Configuration.hotel_api_key = "your_api_key_here"
# Suitcase::Configuration.hotel_cid = "your_cid_here"
# Suitcase::Configuration.hotel_shared_secret = "your_shared_secret_here"
# Suitcase::Configuration.use_signature_auth = true

# Or configure with a block:

Suitcase.configure do |config|
  config.hotel_api_key = ENV['EAN_KEY']
  config.hotel_cid = ENV['EAN_CID']
  
  config.hotwire_api_key = ""
  # config.hotel_shared_secret = "none"
  # config.use_signature_auth = false
end

module Keys
  RESERVATION_START_TIME = Chronic.parse("1 week from now").strftime("%m/%d/%Y")
  RESERVATION_END_TIME = Chronic.parse("2 weeks from now").strftime("%m/%d/%Y")

  SUITCASE_PAYMENT_OPTION = Suitcase::Hotel::PaymentOption.find(currency_code: "USD").find { |po| po.name =~ /Master/ }
  CREDIT_CARD_NUMBER_TESTING = "5401999999999999"
  CREDIT_CARD_CVV_TESTING = "123"
  CREDIT_CARD_EXPIRATION_DATE_TESTING = "2014/03/01"

  SENDING_EMAIL = "testemail@gmail.com"

  VALID_RESERVATION_INFO = {
    email: "testemail@gmail.com",
    first_name: "Test Booking",
    last_name: "Test Booking",
    home_phone: "1231231234",
    payment_option: SUITCASE_PAYMENT_OPTION,
    credit_card_number: CREDIT_CARD_NUMBER_TESTING, 
    credit_card_verification_code: CREDIT_CARD_CVV_TESTING,
    credit_card_expiration_date: CREDIT_CARD_EXPIRATION_DATE_TESTING,
    address1: "travelnow",
    city: "Boston",
    province: "MA",
    country: "US",
    postal_code: "01234",
  }
end
