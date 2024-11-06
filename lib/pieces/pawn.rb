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
    'P'
  end

  def symbol
    @color == :white ? '♙' : '♟'
  end

  def move(dest, chessboard)
    source = chessboard.current_coordinate(self)
    self.moved = true
    chessboard.remove_piece(source)
    chessboard.add_piece(dest, self)
  end

  def can_move_to?(dest, chessboard)
    calculate_possible_moves(chessboard).include?(dest)
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
    return unless !moved && chessboard.find_piece_by_coordinate(two_steps).nil?

    possible_moves << two_steps
  end

  def add_black_capture_moves(file, rank, possible_moves, chessboard)
    left_capture = calculate_square(file, rank - 1, -1)
    right_capture = calculate_square(file, rank - 1, 1)

    down_left_square = chessboard.find_piece_by_coordinate(left_capture)
    down_right_square = chessboard.find_piece_by_coordinate(right_capture)

    possible_moves << left_capture if capturable_by_black?(down_left_square)
    possible_moves << right_capture if capturable_by_black?(down_right_square)
  end

  def add_white_forward_moves(file, rank, possible_moves, chessboard)
    one_step = (file + (rank + 1).to_s).to_sym
    two_steps = (file + (rank + 2).to_s).to_sym

    possible_moves << one_step if chessboard.find_piece_by_coordinate(one_step).nil?
    return unless !moved && chessboard.find_piece_by_coordinate(two_steps).nil?

    possible_moves << two_steps
  end

  def add_white_capture_moves(file, rank, possible_moves, chessboard)
    left_capture = calculate_square(file, rank + 1, -1)
    right_capture = calculate_square(file, rank + 1, 1)

    up_left_square = chessboard.find_piece_by_coordinate(left_capture)
    up_right_square = chessboard.find_piece_by_coordinate(right_capture)

    possible_moves << left_capture if capturable_by_white?(up_left_square)
    possible_moves << right_capture if capturable_by_white?(up_right_square)
  end
end
