# class for chess player
class Player
  attr_reader :name, :side

  def initialize(name = nil, side = nil)
    @name = name
    @side = side
  end
end
