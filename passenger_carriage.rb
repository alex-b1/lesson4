require_relative './carriage.rb'

class PassengerCarriage < Carriage
  def initialize()
    super(:passenger)
  end

end
