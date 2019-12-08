class BaseService
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def call
    data
  end
end