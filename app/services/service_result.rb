class ServiceResult
  attr_reader :success, :message, :data

  def initialize(success, message = nil, data = nil)
    @success = success
    @message = message
    @data = data
  end

  def success?
    @success
  end
end
