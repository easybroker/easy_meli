require "test_helper"

class ApiClientTest < Minitest::Test
  attr_reader :client

  def setup
    @client = EasyMeli::ApiClient.new('test_token')
  end

  def test_get
    body = { "plain_text":"Hello World", "last_updated":"2020-04-23T23:45:22.000Z", "date_created":"2020-04-23T23:40:21.000Z" }

    stub_verb_request(:get, 'test', query: { param1: 1, param2: 2 }).
      to_return(body: body.to_json)
    client.get('test', query: { param1: 1, param2: 2 })
  end

  def test_get_without_access_token
    @client = EasyMeli::ApiClient.new(nil)
    stub_verb_request(:get, 'test', query: { param1: 1, param2: 2 })
    client.get('test', query: { param1: 1, param2: 2 })
  end

  def test_put
    stub_verb_request(:put, 'test', query: { param1: 1, param2: 2 }, body: 'param3=3')
    client.put('test', query: { param1: 1, param2: 2}, body: { param3: 3})
  end

  def test_post
    stub_verb_request(:post, 'test', query: { param1: 1, param2: 2 }, body: 'param3=3')
    client.post('test', query: { param1: 1, param2: 2 }, body: { param3: 3})
  end

  def test_delete
    stub_verb_request(:delete, 'test', query: { param1: 1, param2: 2 })
    client.delete('test', query: { param1: 1, param2: 2 })
  end

  def test_logger
    logger = mock()
    logger.expects(:log).times(4)
    @client = EasyMeli::ApiClient.new('test_token', logger: logger)
    test_get
    test_post
    test_put
    test_delete
  end

  def test_invalid_grant_error
    body = {
      "message":"Error validating grant. Your authorization code or refresh token may be expired or it was already used.",
      "error":"invalid_grant",
      "status":400,
      "cause":[]
    }
    assert_authentication_error(body)
  end

  def test_forbidden_error
    body = { "message":"forbidden", "error":"forbidden", "status":400, "cause":[] }
    assert_authentication_error(body)
  end

  def test_message_error
    body = { "message": "Malformed access_token: test","error": "bad_request", "status": 400, "cause":[]}
    assert_token_error(body)
  end

  def test_invalid_token_error
    body = { "message": "invalid_token", "error": "not_found", "status": 401, "cause":[] }
    assert_token_error(body)
  end

  def test_too_many_requests_error
    body = { "message":"","error": "too_many_requests", "status":429, "cause":[] }

    assert_raises EasyMeli::TooManyRequestsError do
      stub_verb_request(:get, 'test', query: { param1: 1, param2: 2 }).
        to_return(body: body.to_json)
      client.get('test', query: { param1: 1, param2: 2 })
    end
  end

  def test_array_response
    stub_verb_request(:get, 'test', query: { param1: 1, param2: 2 }).
      to_return(body: '[{}, {}]')
    client.get('test', query: { param1: 1, param2: 2 })
  end

  private

  def assert_authentication_error(body)
    assert_raises EasyMeli::AuthenticationError do
      stub_verb_request(:get, 'test', query: { param1: 1, param2: 2 }).
        to_return(body: body.to_json)
      client.get('test', query: { param1: 1, param2: 2 })
    end
  end

  def assert_token_error(body)
    assert_raises EasyMeli::AccessTokenError do
      stub_verb_request(:get, 'test', query: { param1: 1, param2: 2 }).
        to_return(body: body.to_json)
      client.get('test', query: { param1: 1, param2: 2 })
    end
  end

  def stub_verb_request(verb, path, params = {})
    params[:query] = query = params[:query] || {}
    params[:headers] = EasyMeli::DEFAULT_HEADERS
    query[:access_token] = client.access_token if client.access_token
    url = [EasyMeli::ApiClient::API_ROOT_URL, path].join
    stub_request(verb, url).with(params)
  end
end
