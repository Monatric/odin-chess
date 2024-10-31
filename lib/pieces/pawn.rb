require_relative 'piece'

# class for the pawn
class Pawn < Piece
  def initialize(game, color, player, moved = false, en_passant = false)
    super(game, color, player)
    @game = game
    @moved = moved
    @en_passant = en_passant
  end

  def notation
    'P'
  end

  def symbol
    @color == :white ? '♙' : '♟'
  end

  def can_move_to?(dest)
    puts current_coordinate
  end

  def current_coordinate
    game.board.select do |coordinate, data|
      return coordinate if data[:piece] == self
    end
    nil
  end
end
