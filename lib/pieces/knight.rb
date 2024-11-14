require_relative 'piece'

# class for the knight
class Knight < Piece
  KNIGHT_OPTIONS = [
    [2, 1],
    [2, -1],
    [1, 2],
    [1, -2],
    [-2, 1],
    [-2, -1],
    [-1, 2],
    [-1, -2]
  ]

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
    position = chessboard.current_position(self)
    return possible_moves if chessboard.find_coordinate_by_position(position).nil?

    file = position[0]
    rank = position[1]
    add_moves(file, rank, possible_moves, chessboard)

    possible_moves
  end

  def add_moves(file, rank, possible_moves, chessboard)
    KNIGHT_OPTIONS.each do |option|
      position = option[0] + file, option[1] + rank
      coordinate = chessboard.find_coordinate_by_position(position)
      next if coordinate.nil?

      if chessboard.find_piece_by_coordinate(coordinate).nil?
        possible_moves << coordinate
      elsif chessboard.find_piece_by_coordinate(coordinate).color != color
        possible_moves << coordinate
      end
    end
    # later on, consider about checks/pins
  end
end
