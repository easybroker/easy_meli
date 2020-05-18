# frozen_string_literal: true

class EasyMeli::ApiClient
  include HTTParty

  API_ROOT_URL = 'https://api.mercadolibre.com'

  TOKEN_ERRORS = {
    'invalid_grant' => 'Invalid Grant',
    'forbidden' => 'Forbidden',
    'Malformed access_token' => 'Malformed access token'
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
    end
  end

  def check_authentication(response)
    response_message = error_message_from_body(response.to_h) if response.parsed_response.is_a? Hash
    return if response_message.to_s.empty?

    TOKEN_ERRORS.keys.each do |key|
      if response_message.include?(key)
        raise EasyMeli::AuthenticationError.new(TOKEN_ERRORS[key], response)
      end
    end
  end

  def error_message_from_body(body)
    return if body.nil?
    body['error'].to_s.empty? ? body['message'] : body['error']
  end
end
