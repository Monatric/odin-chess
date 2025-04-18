require_relative 'piece'

# class for the pawn
class Pawn < Piece
  attr_accessor :moved, :en_passant
  attr_reader :color

  def initialize(color, moved = false, en_passant = false)
    super(color)
    @moved = moved
    @en_passant = en_passant
    # @possible_moves = []
  end

  def notation
    @color == :white ? 'P' : 'p'
  end

  def symbol
    @color == :white ? '♙' : '♟'
  end

  def move(dest, chessboard)
    self.en_passant = true if self_is_en_passantable?(dest, chessboard)
    if dest == en_passantable_square(chessboard)
      # if dest is 3, this means white pawn is captured at fourth rank
      # else it would be 6, captured black pawn at fifth rank
      opponent_pawn_coordinate = (dest[1] == '3' ? "#{dest[0]}4".to_sym : "#{dest[0]}5".to_sym)
      chessboard.remove_piece(opponent_pawn_coordinate)
    end
    self.moved = true
    super(dest, chessboard)
  end

  # def en_passantable_square(chessboard)
  #   en_passant_rank_offset = 1
  #   current_coordinate = chessboard.current_coordinate(self)
  #   current_file = current_coordinate[0]
  #   current_rank = current_coordinate[1].to_i
  #   if @color == :white
  #     # if rank is 4 then beneath it is 3
  #     (current_file + (current_rank - en_passant_rank_offset).to_s).to_sym
  #   else
  #     # if rank is 5, meaning it's above it or 6
  #     (current_file + (current_rank + en_passant_rank_offset).to_s).to_sym
  #   end
  # end

  def en_passantable_square(chessboard)
    # For ex., if :black, it should return '4' to since that's where an opposing pawn starts
    # to be en_passantable
    result = nil
    rank = (@color == :white ? '5' : '4')
    ('a'..'h').each do |file|
      coordinate = "#{file}#{rank}".to_sym
      # file = (file.ord + 1).chr
      piece = chessboard.find_piece_by_coordinate(coordinate)
      next unless piece.respond_to?(:en_passant) && piece.en_passant == true

      # if rank is 5, meaning it's above it or 6
      # if rank is 4 then beneath it is 3
      rank_behind_pawn = (rank == '5' ? '6' : '3')
      result = (coordinate[0] + rank_behind_pawn).to_sym
    end
    result
  end

  private

  def self_is_en_passantable?(dest, chessboard)
    source = chessboard.current_coordinate(self)
    if source[1] == '2' && dest[1] == '4'
      adjacent_is_opponent_pawn?(dest, chessboard, :black)
    elsif source[1] == '7' && dest[1] == '5'
      adjacent_is_opponent_pawn?(dest, chessboard, :white)
    end
  end

  def adjacent_is_opponent_pawn?(dest, chessboard, color)
    left_adjacent = ((dest.to_s.ord - 1).chr + dest[1]).to_sym
    right_adjacent = ((dest.to_s.ord + 1).chr + dest[1]).to_sym

    # default to dest which is the pawn's new position if coordinate is invalid
    # This avoids error and won't mess up the evaluation because it only
    # evaluates the opposing color. Dest would always be the opposite of opposing color,
    # such as white if color is black
    left_adjacent = dest unless chessboard.coordinate_exist?(left_adjacent)
    right_adjacent = dest unless chessboard.coordinate_exist?(right_adjacent)

    left_adjacent_piece = chessboard.find_piece_by_coordinate(left_adjacent)
    right_adjacent_piece = chessboard.find_piece_by_coordinate(right_adjacent)
    (left_adjacent_piece&.color == color) || (right_adjacent_piece&.color == color)
  end

  def generate_possible_moves(chessboard)
    possible_moves = []
    file = chessboard.current_coordinate(self)[0]
    rank = chessboard.current_coordinate(self)[1].to_i
    add_white_moves(file, rank, possible_moves, chessboard) if color == :white
    add_black_moves(file, rank, possible_moves, chessboard) if color == :black
    possible_moves << en_passantable_square(chessboard)

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
