class EasyMeli::ErrorParser
  ERROR_LIST = {
    'Error validating grant' => EasyMeli::InvalidGrantError,
    'The User ID must match the consultant\'s' => EasyMeli::ForbiddenError,
    'invalid_token' => EasyMeli::InvalidTokenError,
    'Malformed access_token' => EasyMeli::MalformedTokenError,
    'too_many_requests' => EasyMeli::TooManyRequestsError,
    'unknown_error' => EasyMeli::UnknownError
  }

  def self.error_class(body)
    ERROR_LIST.find { |key, _| self.error_message_from_body(body)&.include?(key) }&.last
  end

  private

  def self.error_message_from_body(response)
    response['message'].to_s.empty? ? response['error'] : response['message']
  end
end
