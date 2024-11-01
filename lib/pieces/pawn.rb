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
    add_forward_moves(file, rank, possible_moves)
    add_capture_moves(file, rank, possible_moves)
    possible_moves
  end

  private

  def add_forward_moves(file, rank, possible_moves)
    one_step = (file + (rank + 1).to_s).to_sym
    two_steps = (file + (rank + 2).to_s).to_sym

    possible_moves << one_step
    possible_moves << two_steps unless moved
  end

  def add_capture_moves(file, rank, possible_moves)
    left_capture = calculate_square(file, rank + 1, -1)
    right_capture = calculate_square(file, rank + 1, 1)

    up_left_square = find_piece_by_coordinate(left_capture)
    up_right_square = find_piece_by_coordinate(right_capture)

    possible_moves << left_capture if capturable?(up_left_square)
    possible_moves << right_capture if capturable?(up_right_square)
  end

  def calculate_square(file, rank, file_offset)
    ((file.ord + file_offset).chr + rank.to_s).to_sym
  end

  def capturable?(square)
    !square.nil? && square.color == :black
  end
end
