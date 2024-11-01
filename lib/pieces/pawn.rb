require_relative 'piece'

# class for the pawn
class Pawn < Piece
  attr_accessor :moved, :en_passant
  attr_reader :game, :color, :player

  def initialize(game, color, player, moved = false, en_passant = false)
    super(game, color, player)
    @game = game
    @moved = moved
    @en_passant = en_passant
  end

  def notation
    'P'
  end

  def symbol
    @color == :white ? '♙' : '♟'
  end

  def move(dest)
    # first two lines can be moved to superclass
    game.board[current_coordinate.to_sym][:piece] = nil
    game.board[dest][:piece] = self
    self.moved = true
  end

  def can_move_to?(dest)
    calculate_possible_moves.include?(dest)
  end

  def calculate_possible_moves
    possible_moves = []
    file = current_coordinate[0]
    rank = current_coordinate[1].to_i
    left_capture = (file.ord - 1).chr + (rank + 1).to_s
    right_capture = (file.ord + 1).chr + (rank + 1).to_s
    up_left_square = find_piece_in_square(left_capture.to_sym)
    up_right_square = find_piece_in_square(right_capture.to_sym)
    # capture moves
    if !up_left_square.nil? && up_left_square.color == :black
      possible_moves << left_capture.to_sym
    elsif !up_right_square.nil? && up_right_square.color == :black
      possible_moves << right_capture.to_sym
    end

    one_step = (file + (rank + 1).to_s).to_sym
    two_steps = (file + (rank + 2).to_s).to_sym
    # forward moves
    if !moved
      possible_moves << one_step
      possible_moves << two_steps
    elsif moved
      possible_moves << one_step
    end
    possible_moves
  end
end
