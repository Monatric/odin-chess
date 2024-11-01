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

  def find_piece_in_square(coordinate)
    game.board[coordinate][:piece]
  end

  def find_coordinate_by_position(position)
    col = position[0]
    row = position[1] + 1 # add 1 because of indexing
    file = 'a'
    ((file.ord + col).chr + row.to_s).to_sym
  end

  def current_coordinate
    game.board.select do |coordinate, data|
      return coordinate if data[:piece] == self
    end
    nil
  end

  def current_position
    game.board.select do |_, data|
      return data[:position] if data[:piece] == self
    end
    nil
  end
end
