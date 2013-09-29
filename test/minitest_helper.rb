# Testing frameworks
require "turn"
require "minitest/spec"
require "minitest/autorun"
require "mocha"

# For making sure the dates will be valid
require "chronic"

# Debugger
require "pry"

# The gem
$: << File.dirname(__FILE__) + "/../lib"
$: << File.dirname(__FILE__)
require "suitcase"

# API keys
require "keys"

# Support files
require "support/fake_response"

# Turn configuration
Turn.config do |config|
  config.format = :pretty
  # config.trace = true
  config.natural = true
end
