# frozen_string_literal: true

class EasyMeli::ApiClient
  include HTTParty

  API_ROOT_URL = 'https://api.mercadolibre.com'

  AUTHENTICATION_ERROR_LIST = {
    'invalid_grant' => 'Invalid Grant',
    'forbidden' => 'Forbidden'
  }

  ACCESS_TOKEN_ERROR_LIST = {
    'invalid_token' => 'Invalid Token',
    'Malformed access_token' => 'Malformed access token'
  }

  STATUS_ERRORS = {
    429 => EasyMeli::TooManyRequestsError
  }

  base_uri API_ROOT_URL
  headers EasyMeli::DEFAULT_HEADERS
  format :json

  attr_reader :logger, :access_token

  def initialize(access_token = nil, logger: nil)
    @logger = logger
    @access_token = access_token
  end

  def get(path, query: {})
    send_request(:get, path, query: query)
  end

  def post(path, query: {}, body: {})
    send_request(:post, path, query: query, body: body)
  end

  def put(path, query: {}, body: {})
    send_request(:put, path, query: query, body: body)
  end

  def delete(path, query: {})
    send_request(:delete, path, query: query)
  end

  private

  def send_request(verb, path = '', params = {})
    query = params[:query] || params['query'] || {}
    query[:access_token] = access_token if access_token

    self.class.send(verb, path, params.merge(query)).tap do |response|
      logger&.log response
      check_authentication(response)
      check_status(response)
    end
  end

  def check_authentication(response)
    raise_errors_for(EasyMeli::AuthenticationError, AUTHENTICATION_ERROR_LIST, response)
    raise_errors_for(EasyMeli::InvalidTokenError, ACCESS_TOKEN_ERROR_LIST, response)
  end

  def raise_errors_for(exception, error_list, response)
    response_message = error_message_from_body(response.to_h) if response.parsed_response.is_a? Hash
    return if response_message.to_s.empty?

    error_list.keys.each do |key|
      if response_message.include?(key)
        raise exception.new(error_list[key], response)
      end
    end
  end

  def error_message_from_body(body)
    return if body.nil?
    body['error'].to_s.empty? ? body['message'] : body['error']
  end

  def check_status(response)
    status_error = STATUS_ERRORS[response.code]
    raise status_error.new(response) if status_error
  end
end
