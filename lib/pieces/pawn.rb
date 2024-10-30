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
    puts "test #{@game.board}"
  end
end
