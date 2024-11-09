require_relative 'piece'

# class for the knight
class Knight < Piece
  def notation
    @color == :white ? 'N' : 'n'
  end

  def symbol
    @color == :white ? '♘' : '♞'
  end
end
