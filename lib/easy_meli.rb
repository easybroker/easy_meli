require 'httparty'

require 'easy_meli/version'
require 'easy_meli/errors'
require 'easy_meli/configuration'
require 'easy_meli/authorization_client'
require 'easy_meli/api_client'

module EasyMeli
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
