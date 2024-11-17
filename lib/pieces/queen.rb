require_relative 'piece'

# class for the Bishop
class Queen < Piece
  BISHOP_OPTIONS = [
    # diagonal  
  [-1, 1],
    [1, 1],
    [-1, -1],
    [1, -1],
    # horizontal, vertical
    [0, -1],
    [0, 1],
    [-1, 0],
    [1, 0]
  ]

  def notation
    @color == :white ? 'Q' : 'q'
  end

  def symbol
    @color == :white ? '♕' : '♛'
  end

  def can_move_to?(dest, chessboard)
    calculate_possible_moves(chessboard).include?(dest)
  end

 
end
