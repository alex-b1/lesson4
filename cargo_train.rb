require_relative './train.rb'

class CargoTrain < Train

  def initialize(options)
    super(options)
  end

  def attach_carriage(carriage)
    super if validate_carriage_type? carriage
  end

  private
# validate_carriage_type? используется для проверки типа сагона из объекта не вызывается
  def validate_carriage_type?(carriage)
    carriage.type == :cargo
  end
end
