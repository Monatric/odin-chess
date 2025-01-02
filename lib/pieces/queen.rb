require_relative 'piece'

# class for the Bishop
class Queen < Piece
  QUEEN_OPTIONS = [
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

  private

  def add_moves(file, rank, possible_moves, chessboard)
    QUEEN_OPTIONS.each do |option|
      queen_move = [file, rank]
      calculate_queen_options(possible_moves, chessboard, queen_move, option)
    end
    # later on, consider about checks/pins
  end

  def calculate_queen_options(possible_moves, chessboard, queen_move, option)
    loop do
      queen_move = [queen_move[0] + option[0], queen_move[1] + option[1]]
      coordinate = chessboard.find_coordinate_by_position(queen_move)
      break if coordinate.nil?

      if chessboard.find_piece_by_coordinate(coordinate).nil?
        possible_moves << coordinate
      elsif same_color_in_coordinate?(coordinate, chessboard)
        break
      elsif !same_color_in_coordinate?(coordinate, chessboard)
        possible_moves << coordinate
        break
      end

      # keep in mind the coordinate in possible_moves duplicates
    end
  end
end
