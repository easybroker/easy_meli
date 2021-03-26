# frozen_string_literal: true

class EasyMeli::ApiClient
  include HTTParty

  API_ROOT_URL = 'https://api.mercadolibre.com'

  base_uri API_ROOT_URL
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
    params[:headers] = EasyMeli::DEFAULT_HEADERS.merge(authorization_header)

    self.class.send(verb, path, params.merge(query)).tap do |response|
      logger&.log response
      check_status(response)
      check_for_errors(response)
    end
  end

  def check_status(response)
    exception = EasyMeli::ErrorParser.status_error_class(response)

    if exception
      raise exception.new(response)
    end
  end

  def check_for_errors(response)
    return unless response.parsed_response.is_a?(Hash) && !response.body.nil?

    exception = EasyMeli::ErrorParser.error_class(response)

    if exception
      raise exception.new(response)
    end
  end

  def authorization_header
    return {} unless access_token

    { Authorization: "Bearer #{access_token}" }
  end
end
