require_relative './carriage.rb'

class CargoCarriage < Carriage
  def initialize()
    super(:cargo)
  end
end
