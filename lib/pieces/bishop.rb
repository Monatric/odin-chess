require_relative 'piece'

# class for the Bishop
class Bishop < Piece
  def notation
    @color == :white ? 'B' : 'b'
  end

  def symbol
    @color == :white ? '♗' : '♝'
  end
end
