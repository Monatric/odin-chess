require_relative 'piece'

# class for the Rook
class Rook < Piece
  def notation
    @color == :white ? 'R' : 'r'
  end

  def symbol
    @color == :white ? '♖' : '♜'
  end

  def can_move_to?(dest, chessboard)
    calculate_possible_moves(chessboard).include?(dest)
  end

  private

  def calculate_possible_moves(chessboard)
    possible_moves = []
    position = chessboard.current_position(self)
    return possible_moves if chessboard.find_coordinate_by_position(position).nil? # possibly useless?

    file = position[0]
    rank = position[1]
    add_moves(file, rank, possible_moves, chessboard)

    possible_moves
  end
end
