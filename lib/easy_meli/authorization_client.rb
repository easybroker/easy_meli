# frozen_string_literal: true

class EasyMeli::AuthorizationClient
  include HTTParty

  AUTH_TOKEN_URL = 'https://api.mercadolibre.com/oauth/token'
  AUTH_PATH = '/authorization'
  BASE_AUTH_URLS = {
    AR: 'https://auth.mercadolibre.com.ar',
    BR: 'https://auth.mercadolivre.com.br',
    CO: 'https://auth.mercadolibre.com.co',
    CR: 'https://auth.mercadolibre.com.cr',
    EC: 'https://auth.mercadolibre.com.ec',
    CL: 'https://auth.mercadolibre.cl',
    MX: 'https://auth.mercadolibre.com.mx',
    UY: 'https://auth.mercadolibre.com.uy',
    VE: 'https://auth.mercadolibre.com.ve',
    PA: 'https://auth.mercadolibre.com.pa',
    PE: 'https://auth.mercadolibre.com.pe',
    PT: 'https://auth.mercadolibre.com.pt',
    DO: 'https://auth.mercadolibre.com.do'
  }
  ACCESS_TOKEN_KEY = 'access_token'

  ERROR_LIST = {
    'Error validating grant' => EasyMeli::InvalidGrantError,
    'The User ID must match the consultant\'s' => EasyMeli::ForbiddenError,
    'invalid_token' => EasyMeli::InvalidTokenError,
    'Malformed access_token' => EasyMeli::MalformedTokenError,
    'too_many_requests' => EasyMeli::TooManyRequestsError,
    'unknown_error' => EasyMeli::UnknownError
  }

  headers EasyMeli::DEFAULT_HEADERS
  format :json

  attr_reader :logger

  def initialize(logger: nil)
    @logger = logger
  end

  def self.authorization_url(country_code, redirect_uri)
    params = {
      client_id: EasyMeli.configuration.application_id,
      response_type: 'code',
      redirect_uri: redirect_uri
    }
    HTTParty::Request.new(:get, country_auth_url(country_code), query: params).uri.to_s
  end

  def self.create_token(code, redirect_uri, logger: nil)
    response = self.new(logger: logger).create_token_with_response(code, redirect_uri)
    if response.success?
      response.to_h
    else
      raise EasyMeli::CreateTokenError.new(response)
    end
  end

  def self.access_token(refresh_token, logger: nil)
    response = self.new(logger: logger).access_token_with_response(refresh_token)
    if response.success?
      response.to_h[EasyMeli::AuthorizationClient::ACCESS_TOKEN_KEY]
    else
      exception = self.error_class(response)

      raise exception.new(response)
    end
  end

  def create_token_with_response(code, redirect_uri)
    query_params = merge_auth_params(
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: redirect_uri
    )
    post_auth(query_params)
  end

  def access_token_with_response(refresh_token)
    query_params = merge_auth_params(
      grant_type: 'refresh_token',
      refresh_token: refresh_token
    )
    post_auth(query_params)
  end

  private

  def post_auth(params)
    self.class.post(AUTH_TOKEN_URL, query: params).tap do |response|
      logger&.log response
    end
  end

  def self.country_auth_url(country_code)
    url = BASE_AUTH_URLS[country_code.to_s.upcase.to_sym] ||
      (raise ArgumentError.new('%s is an invalid country code' % country_code))
    [url, AUTH_PATH].join
  end

  def merge_auth_params(options = {})
    options.merge(
      client_id: EasyMeli.configuration.application_id,
      client_secret: EasyMeli.configuration.secret_key
    )
  end

  def self.error_class(body)
    ERROR_LIST.find { |key, _| self.error_message_from_body(body)&.include?(key) }&.last || EasyMeli::InvalidTokenError
  end

  def self.error_message_from_body(response)
    response['message'].to_s.empty? ? response['error'] : response['message']
  end
end
