require "test_helper"

class ErrorParserTest < Minitest::Test
  def test_error_class
    body = {
      "error_description" => "Error validating grant. Your authorization code or refresh token may be expired or it was already used.",
      "error" => "invalid_grant",
      "status" => 400,
      "cause" => []
    }

    assert_equal EasyMeli::InvalidGrantError, EasyMeli::ErrorParser.error_class(body)

    body['message'] = ''
    body['error'] = 'too_many_requests'

    assert_equal EasyMeli::TooManyRequestsError, EasyMeli::ErrorParser.error_class(body)
  end

  def test_status_error_class
    response = mock()
    response.stubs(code: 503)

    assert_equal EasyMeli::ServiceUnavailableError, EasyMeli::ErrorParser.status_error_class(response)

    response = mock()
    response.stubs(code: 599)

    assert_equal EasyMeli::ServerError, EasyMeli::ErrorParser.status_error_class(response)


    response = mock()
    response.stubs(code: 401)

    assert_equal EasyMeli::InvalidTokenError, EasyMeli::ErrorParser.status_error_class(response)

    response.stubs(code: 200)

    assert_nil EasyMeli::ErrorParser.status_error_class(response)
  end
end
