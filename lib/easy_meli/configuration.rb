class EasyMeli::Configuration
  attr_accessor :application_id, :secret_key

  def initialize
    @application_id = nil
    @secret_key = nil
  end
end
