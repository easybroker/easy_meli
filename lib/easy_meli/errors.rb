module EasyMeli
  class Error < StandardError
    attr_reader :response

    def initialize(message, response)
      @response = response
      super(message)
    end
  end

  class AuthenticationError < Error; end
  
  class TooManyRequestsError < Error
    def initialize(response)
      super('Too many requests', response)
    end
  end
end