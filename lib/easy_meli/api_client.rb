# frozen_string_literal: true

class EasyMeli::ApiClient
  include HTTParty

  API_ROOT_URL = 'https://api.mercadolibre.com'

  ERROR_LIST = {
    'Error validating grant' => EasyMeli::InvalidGrantError,
    'forbidden' => EasyMeli::ForbiddenError,
    'invalid_token' => EasyMeli::InvalidTokenError,
    'Malformed access_token' => EasyMeli::MalformedTokenError,
    'too_many_requests' => EasyMeli::TooManyRequestsError
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
      check_for_errors(response)
    end
  end

  def check_for_errors(response)
    return unless response.parsed_response.is_a? Hash

    exception = error_class(response)

    if exception
      raise exception.new(response)
    end
  end

  def error_class(body)
    ERROR_LIST.find { |key, _| error_message_from_body(body).include?(key) }&.last
  end

  def error_message_from_body(response)
    return if response.body.nil?

    response['message'].to_s.empty? ? response['error'] : response['message']
  end
end
