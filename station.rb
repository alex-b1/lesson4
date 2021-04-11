class Station
  attr_accessor :trains, :trains_registr, :name

  def initialize(name)
    @name = name
    @trains = []
    @trains_registr = []
  end

  def arrival_train(train)
    @trains << train

    while train.slow_down > 0
        train.slow_down
    end
  end

  def depart_train(train)
    @trains.filter! {|i| i.number != train.number}
    train.go_ahead

    while train.accelerate < 80
      train.accelerate
    end
  end

  def registrate(train)
    @trains_registr << train
  end

  def get_trains_by_type
   list = {
     cargo: (@trains.filter {|i| i.type == :cargo}).count ,
     passenger: (@trains.filter {|i| i.type == :passenger}).count,
    }
  end
end