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
end
