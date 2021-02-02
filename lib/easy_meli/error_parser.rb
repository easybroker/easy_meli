class EasyMeli::ErrorParser
  ERROR_LIST = {
    'Error validating grant' => EasyMeli::InvalidGrantError,
    'The User ID must match the consultant\'s' => EasyMeli::ForbiddenError,
    'invalid_token' => EasyMeli::InvalidTokenError,
    'Malformed access_token' => EasyMeli::MalformedTokenError,
    'too_many_requests' => EasyMeli::TooManyRequestsError,
    'unknown_error' => EasyMeli::UnknownError
  }

  STATUS_ERRORS = {
    500 => EasyMeli::InternalServerError,
    501 => EasyMeli::NotImplementedError,
    502 => EasyMeli::BadGatewayError,
    503 => EasyMeli::ServiceUnavailableError,
    504 => EasyMeli::GatewayTimeoutError
  }

  def self.error_class(response)
    ERROR_LIST.find { |key, _| self.error_message_from_body(response)&.include?(key) }&.last
  end

  def self.status_error_class(response)
    return unless self.server_side_error?(response)

    STATUS_ERRORS[response.code] || EasyMeli::ServerError
  end

  private

  def self.error_message_from_body(response)
    response['message'].to_s.empty? ? response['error'] : response['message']
  end

  def self.server_side_error?(response)
    response.code >= 500
  end
end
