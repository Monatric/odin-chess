# class for pieces of chess
class Piece
  attr_reader :game, :color, :player

  def initialize(game, color = nil, player = nil)
    @game = game
    @color = color
    @player = player
  end

  def notation
    raise NotImplementedError, 'subclasses must have this method'
  end

  def symbol
    raise NotImplementedError, 'subclasses must have this method'
  end
end
