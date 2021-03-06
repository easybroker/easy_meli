module EasyMeli
  class Error < StandardError
    attr_reader :response

    def initialize(response)
      @response = response
      super(local_message)
    end

    private

    def local_message
      raise NotImplementedError
    end
  end

  class AuthenticationError < Error; end

  class CreateTokenError < AuthenticationError
    private

    def local_message
      'Error Creating Token'
    end
  end

  class InvalidGrantError < AuthenticationError
    private

    def local_message
      'Invalid Grant'
    end
  end

  class ForbiddenError < AuthenticationError
    private

    def local_message
      'Forbidden'
    end
  end

  class AccessTokenError < Error; end

  class InvalidTokenError < AccessTokenError
    private

    def local_message
      'Invalid Token'
    end
  end

  class MalformedTokenError < AccessTokenError
    private

    def local_message
      'Malformed access token'
    end
  end

  class TooManyRequestsError < Error
    private

    def local_message
      'Too many requests'
    end
  end

  class UnknownError < Error
    private

    def local_message
      'Unknown Error'
    end
  end

  class ServerError < Error
    private

    def local_message
      'Server Error'
    end
  end

  class InternalServerError < ServerError
    private

    def local_message
      'Internal Server Error'
    end
  end

  class NotImplementedError < ServerError
    private

    def local_message
      'Not Implemented'
    end
  end

  class BadGatewayError < ServerError
    private

    def local_message
      'Bad Gateway'
    end
  end

  class ServiceUnavailableError < ServerError
    private

    def local_message
      'Service Unavailable'
    end
  end

  class GatewayTimeoutError < ServerError
    private

    def local_message
      'Gateway Timeout'
    end
  end
end
