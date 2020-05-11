$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "easy_meli"

require "minitest/autorun"
require 'webmock/minitest'
require 'mocha/minitest'
require "pry"

EasyMeli.configure do |config|
  config.application_id = 'test_app_id'
  config.secret_key = 'test_secret_key'
end