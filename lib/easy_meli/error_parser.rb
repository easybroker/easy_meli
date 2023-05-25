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
    401 => EasyMeli::InvalidTokenError,
    500 => EasyMeli::InternalServerError,
    501 => EasyMeli::NotImplementedError,
    502 => EasyMeli::BadGatewayError,
    503 => EasyMeli::ServiceUnavailableError,
    504 => EasyMeli::GatewayTimeoutError
  }

  def self.error_class(response)
    find_in_error_list(response['message']) ||
    find_in_error_list(response['error']) ||
    find_in_error_list(response['error_description'])
  end

  def self.status_error_class(response)
    return unless self.status_code_listed?(response) || self.server_side_error?(response)

    STATUS_ERRORS[response.code] || EasyMeli::ServerError
  end

  private

  def self.find_in_error_list(response_field)
    ERROR_LIST.find { |key, _| response_field&.include?(key) }&.last
  end

  def self.server_side_error?(response)
    response.code >= 500
  end

  def self.status_code_listed?(response)
    STATUS_ERRORS.keys.include?(response.code)
  end
end
