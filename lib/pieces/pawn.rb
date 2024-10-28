require_relative 'piece'

# class for the pawn
class Pawn < Piece
  def initialize(color, player, moved = false, en_passant = false)
    super(color, player)
    @moved = moved
    @en_passant = en_passant
  end

  def notation
    'P'
  end

  def symbol
    @color == :white ? '♙' : '♟'
  end
end
