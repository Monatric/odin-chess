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

  attr_accessor :moved, :en_passant

  def initialize(color, player, moved = false)
    super(color, player)
    @moved = moved
  end

  def move(dest, chessboard)
    self.moved = true
    super(dest, chessboard)
  end

  def castle(dest, chessboard)
    self.moved = true
    super(dest, chessboard)
  end

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
    add_castling_moves(file, rank, possible_moves, chessboard)

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

  def add_castling_moves(file, rank, possible_moves, chessboard)
    # check if king has moved
    return if moved

    valid_castle_coordinates(chessboard).each { |coordinate| possible_moves << coordinate }
    # check if no piece blocks the way in short and long

    # check for checks (soon)
    # check if short/long rook has moved
  end

  def valid_castle_coordinates(chessboard) # rubocop:disable Metrics/MethodLength
    castle_paths = {
      white: {
        g1: %i[f1 g1],
        c1: %i[d1 c1 b1]
      },
      black: {
        g8: %i[f8 g8],
        c8: %i[d8 c8 b8]
      }
    }
    results = []
    castle_paths[color].each_pair do |castle_coordinate, path|
      next if rook_moved?(castle_coordinate, chessboard)

      results << castle_coordinate if castle_path_empty?(path, chessboard)
    end
    results
  end

  def rook_moved?(castle_coordinate, chessboard)
    # false if the chosen castle_coordinate is not a rook
    unless chessboard.find_piece_by_coordinate(CASTLING_ROOK_COORDINATE[castle_coordinate]).instance_of?(::Rook)
      return false
    end

    # if the rook has moved
    chessboard.find_piece_by_coordinate(CASTLING_ROOK_COORDINATE[castle_coordinate]).moved
  end

  def castle_path_empty?(path, chessboard)
    path.all? do |coordinate|
      chessboard.find_piece_by_coordinate(coordinate).nil?
    end
  end
end
