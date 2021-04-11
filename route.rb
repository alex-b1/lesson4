class Route
  attr_reader :initial_station, :end_station, :stations

  def initialize(initial_station, end_station)
    @initial_station = initial_station
    @end_station = end_station
    @stations = [initial_station, end_station]
  end

  def add_station(station)
    if validate_station? station
      puts 'Ошибка, такая станция уже есть'
    else
      @stations.insert(-2, station)
    end
  end

  def remove_station(station)
    if validate_station? station
      @stations.delete(station)
    else
      puts 'Ошибка, такой станции нет'
    end
  end

  def get_stations_list
    @stations
  end

  private

  def validate_station?(station)
    @stations.find { |i| i.name == station.name}
  end
end
