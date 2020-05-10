require 'easy_meli/version'
require 'easy_meli/configuration'


module EasyMeli
  class Error < StandardError; end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
