require 'httparty'

require 'easy_meli/version'
require 'easy_meli/constants'
require 'easy_meli/errors'
require 'easy_meli/configuration'
require 'easy_meli/authorization_client'
require 'easy_meli/api_client'

module EasyMeli

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.authorization_url(country_code, redirect_uri)
    EasyMeli::AuthorizationClient.authorization_url(country_code, redirect_uri)
  end

  def self.create_token(code, redirect_uri, logger: nil)
    EasyMeli::AuthorizationClient.create_token(code, redirect_uri, logger: nil)
  end

  def self.refresh_token(refresh_token, logger: nil)
    EasyMeli::AuthorizationClient.refresh_token(refresh_token, logger: nil)
  end

  def self.api_client(access_token: nil, refresh_token: nil, logger: nil)
    access_token = self.refresh_token(refresh_token, logger: logger) if refresh_token
    EasyMeli::ApiClient.new(access_token, logger: logger)
  end
end
