# frozen_string_literal: true

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
    remove_en_passanted_pawn(dest, chessboard) if en_passantable_square(chessboard)
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

  def remove_en_passanted_pawn(dest, chessboard)
    # if dest is 3, this means white pawn is captured at fourth rank
    # else it would be 6, captured black pawn at fifth rank
    rank = dest[0]
    en_passanted_color = (rank == '6' ? :black : :white)
    rank_offset = (en_passanted_color == :white ? -1 : 1)
    opponent_pawn_coordinate = coordinate_string_to_symbol(dest, rank_offset: rank_offset)
    chessboard.remove_piece(opponent_pawn_coordinate)
  end

  def en_passantable_square_finder(adjacent_arr, chessboard)
    coordinate_behind_pawn = nil
    adjacent_arr.each do |adjacent|
      # next unless chessboard.coordinate_exist?(adjacent)

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
    add_moves(possible_moves, chessboard)
    possible_moves << en_passantable_square(chessboard) if @en_passant_signal

    possible_moves
  end

  def add_moves(possible_moves, chessboard)
    current_coordinate = chessboard.current_coordinate(self)

    add_forward_moves(possible_moves, current_coordinate, chessboard)
    add_capture_moves(possible_moves, current_coordinate, chessboard)
  end

  def add_forward_moves(possible_moves, current_coordinate, chessboard)
    one_step_white = 1
    one_step_black = -1
    two_steps_white = 2
    two_steps_black = -2

    one_step_rank_offset = (@color == :white ? one_step_white : one_step_black)
    two_steps_rank_offset = (@color == :white ? two_steps_white : two_steps_black)

    one_step = coordinate_string_to_symbol(current_coordinate, rank_offset: one_step_rank_offset)
    two_steps = coordinate_string_to_symbol(current_coordinate, rank_offset: two_steps_rank_offset)

    possible_moves << one_step if chessboard.find_piece_by_coordinate(one_step).nil?
    possible_moves << two_steps if eligible_for_two_steps(chessboard, one_step, two_steps)
  end

  # pawn cannot move two steps if there is a piece or has moved
  def eligible_for_two_steps(chessboard, one_step, two_steps)
    !moved &&
      chessboard.find_piece_by_coordinate(one_step).nil? &&
      chessboard.find_piece_by_coordinate(two_steps).nil?
  end

  def add_capture_moves(possible_moves, current_coordinate, chessboard)
    offset = { up_and_right: 1, down_and_left: -1 }
    white_rank_offset = offset[:up_and_right]
    black_rank_offset = offset[:down_and_left]
    rank_offset = (@color == :white ? white_rank_offset : black_rank_offset)

    diag_left_capture = coordinate_string_to_symbol(current_coordinate, file_offset: offset[:down_and_left],
                                                                        rank_offset: rank_offset)
    diag_right_capture = coordinate_string_to_symbol(current_coordinate, file_offset: offset[:up_and_right],
                                                                         rank_offset: rank_offset)

    diag_left_piece = chessboard.find_piece_by_coordinate(diag_left_capture)
    diag_right_piece = chessboard.find_piece_by_coordinate(diag_right_capture)

    possible_moves << diag_left_capture if capturable?(diag_left_piece, @color)
    possible_moves << diag_right_capture if capturable?(diag_right_piece, @color)
  end
end
