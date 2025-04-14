require_relative 'piece'

# class for the pawn
class Pawn < Piece
  attr_accessor :moved, :en_passant_signal, :en_passant_signaller
  attr_reader :color

  def initialize(color, moved = false, en_passant_signal = false, en_passant_signaller = false)
    super(color)
    @moved = moved
    @en_passant_signal = en_passant_signal
    @en_passant_signaller = en_passant_signaller
    # @possible_moves = []
  end

  def notation
    @color == :white ? 'P' : 'p'
  end

  def symbol
    @color == :white ? '♙' : '♟'
  end

  def move(dest, chessboard)
    @en_passant_signaller = false if @en_passant_signaller
    signal_en_passant(dest, chessboard) if self_is_en_passantable?(dest, chessboard)
    if dest == en_passantable_square(chessboard)
      # if dest is 3, this means white pawn is captured at fourth rank
      # else it would be 6, captured black pawn at fifth rank
      opponent_pawn_coordinate = (dest[1] == '3' ? "#{dest[0]}4".to_sym : "#{dest[0]}5".to_sym)
      chessboard.remove_piece(opponent_pawn_coordinate)
    end
    self.moved = true
    super(dest, chessboard)
  end

  def signal_en_passant(dest, chessboard)
    left_adjacent = coordinate_string_to_symbol(dest, file_offset: -1)
    right_adjacent = coordinate_string_to_symbol(dest, file_offset: 1)

    [left_adjacent, right_adjacent].each do |adjacent|
      next unless chessboard.coordinate_exist?(adjacent)

      piece = chessboard.find_piece_by_coordinate(adjacent)
      piece.en_passant_signal = true if piece.respond_to?(:en_passant_signal)
      @en_passant_signaller = true
    end
  end

  def en_passantable_square(chessboard)
    return unless en_passant_signal

    source = chessboard.current_coordinate(self)
    left_adjacent = coordinate_string_to_symbol(source, file_offset: -1)
    right_adjacent = coordinate_string_to_symbol(source, file_offset: 1)

    en_passantable_square_finder([left_adjacent, right_adjacent], chessboard)
  end

  private

  def en_passantable_square_finder(adjacent_arr, chessboard)
    coordinate_behind_pawn = nil
    adjacent_arr.each do |adjacent|
      next unless chessboard.coordinate_exist?(adjacent)

      piece = chessboard.find_piece_by_coordinate(adjacent)

      next unless piece.respond_to?(:en_passant_signal) && piece.en_passant_signaller

      # imagine this happening as the current player. The current player, say a white and its pawn, will
      # look for the square behind the black pawny
      rank_behind_white_pawn = -1
      rank_behind_black_pawn = 1
      rank_offset = (@color == :white ? rank_behind_black_pawn : rank_behind_white_pawn)
      coordinate_behind_pawn = coordinate_string_to_symbol(adjacent, rank_offset: rank_offset)
    end
    coordinate_behind_pawn
  end

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
    possible_moves << en_passantable_square(chessboard) if @en_passant_signal

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
