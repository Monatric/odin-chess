require_relative 'piece'

# class for the Bishop
class King < Piece
  KING_OPTIONS = [
    [0, 1], # forward
    [1, 1], # upright
    [1, 0], # right
    [1, -1], # downright
    [0, -1], # down
    [-1, -1], # downleft
    [-1, 0], # left
    [-1, 1] # upleft
  ]

  def notation
    @color == :white ? 'K' : 'k'
  end

  def symbol
    @color == :white ? '♔' : '♚'
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
    add_basic_moves(file, rank, possible_moves, chessboard)

    p possible_moves
    # later on, consider about checks/pins
  end

  def add_basic_moves(file, rank, possible_moves, chessboard)
    KING_OPTIONS.each do |option|
      position = option[0] + file, option[1] + rank
      coordinate = chessboard.find_coordinate_by_position(position)
      next if coordinate.nil?

      if chessboard.find_piece_by_coordinate(coordinate).nil?
        possible_moves << coordinate
      elsif chessboard.find_piece_by_coordinate(coordinate).color != color
        possible_moves << coordinate
      end
    end
  end
end
