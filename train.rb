class Train
  attr_reader :carriages, :number, :type, :speed, :station, :is_move, :route

  def initialize(options)
    @number = options[:number]
    @type = options[:type]
    @carriages = [].concat(options[:carriages])
    @speed = 0
  end

  def accelerate(speed = 10)
    @speed += speed
  end

  def slow_down(speed = 10)
    @speed = @speed < speed ? 0 : @speed - speed
  end

  def attach_carriage(carriage)
    if !validate_speed?
      @carriages << carriage
      puts @carriages
      @carriages
    else
      puts 'Поезд движется'
      @carriages
    end
  end

  def detach_carriage
    if !validate_speed?
      @carriages.pop
      puts @carriages
      @carriages
    else
      puts 'Поезд движется'
      @carriages
    end
  end

  def route(route)
    @route = route
    @station = @route.stations.first
    @route.stations.each do |i|
       i.registrate self
    end
    puts "Вы на станции: #{@station}"
    @route.get_stations_list
  end

  def go_ahead
    @station = next_station if next_station
    @station
  end

  def go_back
    @station = previous_station if previous_station
    @station
  end

  private

# validate_speed? используется только в классе Train для проверки скорости
  def validate_speed?
    @speed > 0
  end

# next_station, previous_station также будем использовать для проверки, что станция не конечная

  def next_station
    index = @route.stations.index @station
    length = @route.stations.length
    if index == length
      puts 'вы на последней станции'
    else
      @route.stations[index + 1]
    end
  end

  def previous_station
    index = @route.stations.index @station
    if index == 0
      puts 'Вы на первой станции'
    else
      @route.stations[index - 1]
    end
  end
end


