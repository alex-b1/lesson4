require_relative './train.rb'
require_relative './cargo_train.rb'
require_relative './passenger_train.rb'
require_relative './carriage.rb'
require_relative './passenger_carriage.rb'
require_relative './cargo_carriage.rb'
require_relative './route.rb'
require_relative './station.rb'

class Main

  def initialize
    @trains_list = []
    @routes_list = []
    @stations_list = []
    @command_list = {
        1 => {title: 'Создать станцию', command: -> {create_station}},
        2 => {title: 'Создать поезд', command: -> {create_train}},
        3 => {title: 'Создать маршрут', command: -> {create_route}},
        4 => {title: 'Добавить станцию в маршруту', command: -> {add_station_to_route}},
        5 => {title: 'Удалить станцию из маршрута', command: -> {remove_station_from_route}},
        6 => {title: 'Назначить маршрут поезду', command: -> {set_route}},
        7 => {title: 'Добавлить вагон к поезду', command: -> {add_carriage}},
        8 => {title: 'Отцепить вагон от поезда', command: -> {remove_carriage}},
        9 => {title: 'Перемещать поезд по маршруту вперед', command: -> {go_ahead}},
        10 => {title: 'Перемещать поезд по маршруту назад', command: -> {go_back}},
        11 => {title: 'Просматривать список станций', command: -> {show_stations}},
        12 => {title: 'Просматривать список поездов на станции', command: -> {show_trains_on_station}},
    }
  end

  def dispatch
    loop do
      clear
      show_tasks
      task = get_task
      break if !@command_list[task]
      puts @command_list[task][:command].call
      continue
    end
    print "Вы вышли из программы"
  end

  private
  attr_accessor :stations_list, :routes_list, :trains_list

  def clear
    if Gem.win_platform?
      system 'cls'
    else
      system 'clear'
    end
  end

  def show_tasks
    puts 'Введите номер задачи : '
    @command_list.each do |k, v|
      puts "#{k} - #{v[:title]}"
    end
  end

  def get_task
    gets.chomp.to_i
  end

  def get_string
    gets.chomp.to_s.downcase.strip
  end

  def create_station
    print 'Ведите название станции: '
    name = get_string
    station = Station.new(name)
    @stations_list.push({
       name: name,
       station: station,
    })
  end

  def create_train
    train_options = {}
    print 'Ведите номер поезда: '
    train_options[:number] = get_string
    print 'Ведите тип поезда: '
    train_options[:type] = get_string.to_sym
    print 'Ведите кол-во вагонов поезда: '
    count = get_string.to_i

    train_options[:carriages] = []
    count.times do |i|
      if train_options[:type] == :cargo
        train_options[:carriages].push(CargoCarriage.new)
      elsif train_options[:type] == :passenger
        train_options[:carriages].push(PassengerCarriage.new)
      end
    end

    train = train_options[:type] == :cargo ? CargoTrain.new(train_options) : PassengerTrain.new(train_options)

    @trains_list.push({
       number: train_options[:number],
       train: train,
     })
  end

  def create_route
    @stations_list.each do |i|
      puts "Станция : #{i[:name]}"
    end
    print 'Ведите начальную и конечную станцию через дефис: '
    name = get_string.split('-')

    first_station = @stations_list.find {|i| i[:name] == name[0]}
    last_station = @stations_list.find {|i| i[:name] == name[1]}

    route = Route.new(first_station[:station], last_station[:station])

    @routes_list.push({
       name: name.join('-'),
       route: route,
    })
  end

  def select_route
    puts 'Выберите маршрут для поезда: '

    @routes_list.each do |i|
      puts "маршрут : #{i[:name]}"
    end

    name = get_string
    route_item = @routes_list.find {|i| i[:name] == name}
    route = route_item[:route]
  end

  def select_station
    puts 'Выберите станцию: '

    @stations_list.each do |i|
      puts "Станция : #{i[:name]}"
    end

    name = get_string
    station_item = @stations_list.find {|j| j[:name] == name}
    station = station_item[:station]
  end

  def select_train
    puts 'Выберите поезд: '

    @trains_list.each do |i|
      puts "Поезд номер : #{i[:number]}"
    end

    number = get_string
    train_item = @trains_list.find {|j| j[:number] == number}
    train = train_item[:train]
  end

  def add_station_to_route
    route = select_route
    station = select_station

    route.add_station station
  end

  def remove_station_from_route
    route = select_route
    station = select_station

    route.remove_station station
  end

  def set_route
    train = select_train
    route = select_route

    train.route route
  end

  def add_carriage
    train = select_train

    carriage = train.type == :cargo ? CargoCarriage.new : PassengerCarriage.new
    train.attach_carriage(carriage)
  end

  def remove_carriage
    train = select_train

    if train.carriages.length == 0
      puts "Вагон больше нет"
      return
    end

    train.detach_carriage
  end

  def go_ahead
    train = select_train
    train.go_ahead
  end

  def go_back
    train = select_train
    train.go_back
  end

  def show_stations
    puts @stations_list
  end

  def show_trains_on_station
    station = select_station

    puts station.trains
    puts station.trains_registr
  end

  def continue
    puts "нажмите любуюклавишу чтобы продолжить"
    gets
  end
end

main = Main.new
main.dispatch