require_relative 'piece'

# class for the Bishop
class Bishop < Piece
  def notation
    @color == :white ? 'B' : 'b'
  end

  def symbol
    @color == :white ? '♗' : '♝'
  end

  def move(dest, chessboard)
    source = chessboard.current_coordinate(self)
    chessboard.remove_piece(source)
    chessboard.add_piece(dest, self)
  end
end
