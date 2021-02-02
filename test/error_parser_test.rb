require "test_helper"

class ErrorParserTest < Minitest::Test
  def test_error_class
    body = {
      "message" => "Error validating grant. Your authorization code or refresh token may be expired or it was already used.",
      "error" => "invalid_grant",
      "status" => 400,
      "cause" => []
    }

    assert_equal EasyMeli::InvalidGrantError, EasyMeli::ErrorParser.error_class(body)

    body['message'] = ''
    body['error'] = 'too_many_requests'

    assert_equal EasyMeli::TooManyRequestsError, EasyMeli::ErrorParser.error_class(body)
  end
end
