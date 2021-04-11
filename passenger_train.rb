require_relative './train.rb'

class PassengerTrain < Train

  def initialize(options)
    super(options)
  end

  def attach_carriage
    super if validate_carriage_type?
  end

  private

# validate_carriage_type? используется для проверки типа сагона из объекта не вызывается
  def validate_carriage_type?(carriage)
    carriage.type == :passenger
  end
end
