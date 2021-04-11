require_relative './train.rb'
require_relative './cargo_train.rb'
require_relative './passenger_train.rb'
require_relative './carriage.rb'
require_relative './passenger_carriage.rb'
require_relative './cargo_carriage.rb'
require_relative './route.rb'
require_relative './station.rb'

trains_list = []
routes_list = []
stations_list = []

cargo_carriage = CargoCarriage.new
passenger_carriage = PassengerCarriage.new

loop do
  print 'Ведите название станции: '
  station_name = gets.chomp.to_s

  station = Station.new(station_name)

  stations_list.push({
    name: station_name,
    station: station,
  })

  print 'Создать еще одну станцию ? (Да/Нет): '
  is_one_more = gets.chomp.to_s.downcase

  break if is_one_more != 'да'
end

loop do
  train_options = {}
  print 'Ведите номер поезда: '
  train_options[:number] = gets.chomp.to_s
  print 'Ведите тип поезда: '
  train_options[:type] = gets.chomp.to_sym
  print 'Ведите кол-во вагонов поезда: '
  count = gets.chomp.to_i

  train_options[:carriages] = []
  count.times do |i|
    if train_options[:type] == :cargo
      train_options[:carriages].push(cargo_carriage)
    elsif train_options[:type] == :passenger
      train_options[:carriages].push(passenger_carriage)
    end
  end

  train = train_options[:type] == :cargo ? CargoTrain.new(train_options) : PassengerTrain.new(train_options)

  trains_list.push({
    number: train_options[:number],
    train: train,
  })

  print 'Создать еще один поезд ? (Да/Нет): '
  is_one_more = gets.chomp.to_s.downcase

  break if is_one_more != 'да'
end

loop do
  print 'Ведите начальную и конечную станцию через дефис: '
  name = gets.chomp.to_s.delete(' ').downcase.split('-')

  first_station = stations_list.find {|i| i[:name] == name[0]}
  last_station = stations_list.find {|i| i[:name] == name[1]}

  route = Route.new(first_station[:station], last_station[:station])

  print 'Хотите добавить доп. станции? (Да/Нет): '
  is_new_stations = gets.chomp.to_s.downcase

  if is_new_stations == 'да'
    print 'Введите список промежуточных станций через запятую: '
    stations = gets.chomp.to_s.delete(' ').downcase.split(',')
    stations.each do |i|
      add_station = stations_list.find {|j| j[:name] == i}
      if add_station
        route.add_station add_station[:station]
      end
    end

    p route
  end

  routes_list.push({
      name: name.join('-'),
      route: route,
  })

  print 'Создать еще один маршрут ? (Да/Нет): '
  is_one_more = gets.chomp.to_s.downcase

  break if is_one_more != 'да'
end

puts 'Выберите поезд: '

trains_list.each do |i|
  puts "поезда номер: #{i[:number]}"
end

selected_namber = gets.chomp.to_s
selected_train_item = trains_list.find {|i| i[:number] == selected_namber}
selected_train = selected_train_item[:train]

puts 'Выберите маршрут для поезда: '

routes_list.each do |i|
  puts "маршрут : #{i[:name]}"
end

selected_route_name = gets.chomp.to_s.delete(' ').downcase

selected_route_item = routes_list.find {|i| i[:name] == selected_route_name}
selected_route = selected_route_item[:route]
route_stations = selected_route.get_stations_list

selected_train.route selected_route

loop do
  print 'Добавить вагон ? '
  add_carriage = gets.chomp.to_s.downcase

  if add_carriage == 'да'
    carriage = selected_train.type == :cargo ? cargo_carriage : passenger_carriage
    selected_train.attach_carriage(carriage)
  end

  break if add_carriage != 'да'
end

loop do
  print 'Удалить вагон ? '
  remove_carriage = gets.chomp.to_s.downcase

  if remove_carriage == 'да'
    carriage = selected_train.type == :cargo ? cargo_carriage : passenger_carriage
    selected_train.detach_carriage
  end

  break if remove_carriage != 'да' || selected_train.carriages.length == 0
end

loop do
  print 'Едем дальше ? '
  ahead = gets.chomp.to_s.downcase
  current_station = ''
  current_station_index = ''

  if ahead == 'да'
    current_station = selected_train.go_ahead
    current_station_index = selected_route.get_stations_list.index {|i| i.name == current_station.name}
  end

  break if (ahead != 'да' || current_station_index == (selected_route.get_stations_list.length - 1))
end

loop do
  print 'Едем назад ? '
  back = gets.chomp.to_s.downcase
  current_station = ''
  current_station_index = ''

  if back == 'да'
    current_station = selected_train.go_back
    current_station_index = selected_route.get_stations_list.index {|i| i.name == current_station.name}
  end

  break if back != 'да' || current_station_index == 0
end

print 'Показать список станций ? '
show_station_list = gets.chomp.to_s.downcase

if show_station_list == 'да'
  puts stations_list
end

print 'Показать список поездов на станции ? '
train_on_station = gets.chomp.to_s.downcase

if train_on_station == 'да'
  print 'Введите название станции для просмотра поездов ? '
  station_title = gets.chomp.to_s.downcase
  station_selected = stations_list.find {|i| i[:name] == station_title}

  puts station_selected[:station].trains
  puts station_selected[:station].trains_registr
end