require "test_helper"

class AuthorizationClientTest < Minitest::Test
  DUMMY_TOKEN_RESPONSE = {
    'access_token' => "APP_USR-123",
    'token_type' => 'bearer',
    'expires_in' => 10800,
    'scope' => 'offline_access read write',
    'user_id' => 8035443,
    'refresh_token' => 'TG-123'
  }

  def test_authorization_url(country_code = :AR)
    url = EasyMeli::AuthorizationClient.authorization_url(country_code, 'foo')
    assert_equal 'https://auth.mercadolibre.com.ar/authorization?client_id=test_app_id&response_type=code&redirect_uri=foo', url
  end

  def test_authorization_url_with_lower_case_country
    test_authorization_url(:ar)
    test_authorization_url('ar')
  end

  def test_authorization_url_with_invalid_country
    assert_raises ArgumentError do
      EasyMeli::AuthorizationClient.authorization_url('foo', 'bar')
    end
  end

  def test_create_token_with_response(logger = nil)
    stub_auth_request(
      code: 'test_code',
      grant_type: 'authorization_code',
      redirect_uri: 'test_redirect_uri'
    )

    response = EasyMeli::AuthorizationClient.new(logger: logger).
      create_token_with_response('test_code', 'test_redirect_uri')

    assert_equal(DUMMY_TOKEN_RESPONSE, response.to_h)
  end

  def test_create_token
    stub_auth_request(
      code: 'test_code',
      grant_type: 'authorization_code',
      redirect_uri: 'test_redirect_uri'
    )
    response = EasyMeli::AuthorizationClient.create_token('test_code', 'test_redirect_uri')
    assert_equal DUMMY_TOKEN_RESPONSE, response
  end

  def test_create_token_fail
    stub_auth_request(
      code: 'test_code',
      grant_type: 'authorization_code',
      redirect_uri: 'test_redirect_uri',
      response_status: 403
    )
    assert_raises EasyMeli::AuthenticationError do
      EasyMeli::AuthorizationClient.create_token('test_code', 'test_redirect_uri')
    end
  end

  def test_create_token_logger
    logger = mock()
    logger.expects(:log)
    test_create_token_with_response(logger)
  end

  def test_access_token
    stub_auth_request(grant_type: 'refresh_token', refresh_token: 'test_token')
    access_token = EasyMeli::AuthorizationClient.access_token('test_token')
    assert_equal DUMMY_TOKEN_RESPONSE['access_token'], access_token
  end

  def test_access_token_fail
    stub_auth_request(
      grant_type: 'refresh_token',
      refresh_token: 'test_token',
      response_status: 403)

    assert_raises EasyMeli::AuthenticationError do
      EasyMeli::AuthorizationClient.access_token('test_token')
    end
  end

  def test_access_token_with_response(logger = nil)
    stub_auth_request(grant_type: 'refresh_token', refresh_token: 'test_token')
    response = EasyMeli::AuthorizationClient.new(logger: logger).
      access_token_with_response('test_token')

    assert_equal(DUMMY_TOKEN_RESPONSE, response.to_h)
  end

  def test_refresh_token_logger
    logger = mock()
    logger.expects(:log)
    test_access_token_with_response(logger)
  end

  private

  def stub_auth_request(params = {})
    response_status = params.delete(:response_status) || 200
    stub_request(:post, EasyMeli::AuthorizationClient::AUTH_TOKEN_URL).
      with(query:
        params.merge(
          client_id: 'test_app_id',
          client_secret: 'test_secret_key'
        ),
        headers: EasyMeli::DEFAULT_HEADERS
      ).
      to_return(body: DUMMY_TOKEN_RESPONSE.to_json, status: response_status)
  end
end
