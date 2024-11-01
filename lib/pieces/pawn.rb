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
    position = current_position
    forward_moves(position, possible_moves)
    find_capture_moves(position, possible_moves)
    possible_moves
  end

  private

  def forward_moves(position, possible_moves)
    one_step = [position[0], position[1] + 1]
    two_steps = [position[0], position[1] + 2]

    # forward moves
    if !moved
      possible_moves << find_coordinate_by_position(one_step)
      possible_moves << find_coordinate_by_position(two_steps)
    elsif moved
      possible_moves << find_coordinate_by_position(one_step)
    end
  end

  def find_capture_moves(position, possible_moves)
    left_capture = [position[0] - 1, position[1] + 1]
    right_capture = [position[0] + 1, position[1] + 1]
    up_left_square = find_piece_by_position(left_capture)
    up_right_square = find_piece_by_position(right_capture)
    # capture moves
    if !up_left_square.nil? && up_left_square.color == :black
      possible_moves << find_coordinate_by_position(left_capture)
    elsif !up_right_square.nil? && up_right_square.color == :black
      possible_moves << find_coordinate_by_position(right_capture)
    end
  end
end
