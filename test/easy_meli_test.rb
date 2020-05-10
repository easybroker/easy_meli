require "test_helper"

class EasyMeliTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::EasyMeli::VERSION
  end

  def test_config
    EasyMeli.configure do |config|
      config.application_id = 'foo'
      config.secret_key = 'bar'
    end
    assert_equal 'foo', EasyMeli.configuration.application_id
    assert_equal 'bar', EasyMeli.configuration.secret_key
  end
end
