require_relative 'piece'

# class for the knight
class Knight < Piece
  def notation
    @color == :white ? 'N' : 'n'
  end

  def symbol
    @color == :white ? '♘' : '♞'
  end

  def can_move_to?(dest, chessboard)
    calculate_possible_moves(chessboard).include?(dest)
  end

  private

  def calculate_possible_moves(chessboard)
    possible_moves = []
    file = chessboard.current_coordinate(self)[0]
    rank = chessboard.current_coordinate(self)[1].to_i
    add_moves(file, rank, possible_moves, chessboard)

    possible_moves
  end
end
