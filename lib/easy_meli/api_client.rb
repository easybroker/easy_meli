# frozen_string_literal: true

class EasyMeli::ApiClient
  include HTTParty

  API_ROOT_URL = 'https://api.mercadolibre.com'

  base_uri API_ROOT_URL 
  format :json

  attr_reader :logger, :access_token

  def initialize(access_token, logger: nil)
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
    query[:access_token] = access_token
    self.class.send(verb, path, params.merge(query)) do |response|
      logger&.log response
      # raise if not authenticated
    end
  end
end