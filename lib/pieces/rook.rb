require_relative 'piece'

# class for the Rook
class Rook < Piece
  attr_accessor :moved

  ROOK_OPTIONS = [
    [0, -1],
    [0, 1],
    [-1, 0],
    [1, 0]
  ]

  def initialize(color, player, moved = false)
    super(color, player)
    @moved = moved
  end

  def move(dest, chessboard)
    self.moved = true
    super(dest, chessboard)
  end

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

  def add_moves(file, rank, possible_moves, chessboard)
    ROOK_OPTIONS.each do |option|
      rook_move = [file, rank]
      calculate_rook_options(possible_moves, chessboard, rook_move, option)
    end
    # later on, consider about checks/pins
  end

  def calculate_rook_options(possible_moves, chessboard, rook_move, option)
    loop do
      rook_move = [rook_move[0] + option[0], rook_move[1] + option[1]]
      coordinate = chessboard.find_coordinate_by_position(rook_move)
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
