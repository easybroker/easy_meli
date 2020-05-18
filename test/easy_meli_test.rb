require "test_helper"

class EasyMeliTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::EasyMeli::VERSION
  end

  def test_config
    # The config is set in test_helper
    assert_equal 'test_app_id', EasyMeli.configuration.application_id
    assert_equal 'test_secret_key', EasyMeli.configuration.secret_key
  end

  def test_authorization_url
    assert EasyMeli.authorization_url(:ar, 'test')
  end

  def test_create_token
    EasyMeli::AuthorizationClient.expects(:create_token).with('foo', 'bar', logger: nil)
    EasyMeli.create_token('foo', 'bar')
  end

  def test_refresh_token
    EasyMeli::AuthorizationClient.expects(:refresh_token).with('foo', logger: nil)
    EasyMeli.refresh_token('foo')
  end

  def test_api_client_with_refresh_token
    EasyMeli::AuthorizationClient.expects(:refresh_token).with('foo', logger: nil).returns('bar')
    EasyMeli::ApiClient.expects(:new).with('bar', logger: nil)
    EasyMeli.api_client(refresh_token: 'foo')
  end

  def test_api_client_with_access_token
    EasyMeli::ApiClient.expects(:new).with('bar', logger: nil)
    EasyMeli.api_client(access_token: 'bar')
  end

  def test_api_client_without_tokens
    EasyMeli::ApiClient.expects(:new).with(nil, logger: nil)
    EasyMeli.api_client
  end
end
