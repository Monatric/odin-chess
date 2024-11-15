require_relative 'piece'

# class for the Bishop
class Bishop < Piece
  BISHOP_OPTIONS = [
    [-1, 1],
    [1, 1],
    [-1, -1],
    [1, -1]
  ]

  def notation
    @color == :white ? 'B' : 'b'
  end

  def symbol
    @color == :white ? '♗' : '♝'
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

  def add_moves(file, rank, possible_moves, chessboard)
    BISHOP_OPTIONS.each do |option|
      bishop_move = [file, rank]
      calculate_bishop_options(possible_moves, chessboard, bishop_move, option)
    end
    # later on, consider about checks/pins
  end

  def calculate_bishop_options(possible_moves, chessboard, bishop_move, option)
    loop do
      bishop_move = [bishop_move[0] + option[0], bishop_move[1] + option[1]]
      coordinate = chessboard.find_coordinate_by_position(bishop_move)
      break if coordinate.nil?

      if chessboard.find_piece_by_coordinate(coordinate).nil?
        possible_moves << coordinate
      elsif same_color_in_square?(coordinate, chessboard)
        break
      elsif !same_color_in_square?(coordinate, chessboard)
        possible_moves << coordinate
        break
      end

      # keep in mind the coordinate in possible_moves duplicates
    end
  end

  def same_color_in_square?(coordinate, chessboard)
    piece = chessboard.find_piece_by_coordinate(coordinate)
    return false if piece.nil?

    piece.color == color
  end
end
