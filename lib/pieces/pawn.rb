require_relative 'piece'

# class for the pawn
class Pawn < Piece
  attr_accessor :moved, :en_passant
  attr_reader :color, :player

  def initialize(color, player, moved = false, en_passant = false)
    super(color, player)
    @moved = moved
    @en_passant = en_passant
  end

  def notation
    @color == :white ? 'P' : 'p'
  end

  def symbol
    @color == :white ? '♙' : '♟'
  end

  def move(dest, chessboard)
    self.moved = true
    super(dest, chessboard)
  end

  private

  def calculate_possible_moves(chessboard)
    possible_moves = []
    file = chessboard.current_coordinate(self)[0]
    rank = chessboard.current_coordinate(self)[1].to_i
    add_white_moves(file, rank, possible_moves, chessboard) if color == :white
    add_black_moves(file, rank, possible_moves, chessboard) if color == :black

    possible_moves
  end

  def add_white_moves(file, rank, possible_moves, chessboard)
    add_white_forward_moves(file, rank, possible_moves, chessboard)
    add_white_capture_moves(file, rank, possible_moves, chessboard)
  end

  def add_black_moves(file, rank, possible_moves, chessboard)
    add_black_forward_moves(file, rank, possible_moves, chessboard)
    add_black_capture_moves(file, rank, possible_moves, chessboard)
  end

  def add_black_forward_moves(file, rank, possible_moves, chessboard)
    one_step = (file + (rank - 1).to_s).to_sym
    two_steps = (file + (rank - 2).to_s).to_sym

    possible_moves << one_step if chessboard.find_piece_by_coordinate(one_step).nil?
    return unless !moved && 
                  chessboard.find_piece_by_coordinate(one_step).nil? &&
                  chessboard.find_piece_by_coordinate(two_steps).nil?

    possible_moves << two_steps
  end

  def add_black_capture_moves(file, rank, possible_moves, chessboard)
    left_capture = calculate_square(file, rank - 1, -1)
    right_capture = calculate_square(file, rank - 1, 1)

    down_left = chessboard.find_piece_by_coordinate(left_capture) if chessboard.coordinate_exist?(left_capture)
    down_right = chessboard.find_piece_by_coordinate(right_capture) if chessboard.coordinate_exist?(right_capture)

    possible_moves << left_capture if capturable_by_black?(down_left)
    possible_moves << right_capture if capturable_by_black?(down_right)
  end

  def add_white_forward_moves(file, rank, possible_moves, chessboard)
    one_step = (file + (rank + 1).to_s).to_sym
    two_steps = (file + (rank + 2).to_s).to_sym

    possible_moves << one_step if chessboard.find_piece_by_coordinate(one_step).nil?
    # pawn cannot move two steps if there is a piece or has moved
    return unless !moved &&
           chessboard.find_piece_by_coordinate(one_step).nil? &&
           chessboard.find_piece_by_coordinate(two_steps).nil?
      
      possible_moves << two_steps
  end

  def add_white_capture_moves(file, rank, possible_moves, chessboard)
    left_capture = calculate_square(file, rank + 1, -1)
    right_capture = calculate_square(file, rank + 1, 1)

    up_left = chessboard.find_piece_by_coordinate(left_capture) if chessboard.coordinate_exist?(left_capture)
    up_right = chessboard.find_piece_by_coordinate(right_capture) if chessboard.coordinate_exist?(right_capture)

    possible_moves << left_capture if capturable_by_white?(up_left)
    possible_moves << right_capture if capturable_by_white?(up_right)
  end
end
