# frozen_string_literal: true

require_relative '../piece'
require_relative 'advanced_piece_movement/pawn_en_passant'
require_relative 'advanced_piece_movement/pawn_promotion'

module Chess
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

    def promote(dest, chessboard, dup: false)
      promotion_piece = PawnPromotion.select_promotion_piece(@color, dup: dup)
      refresh_en_passant(chessboard) # a player's move will reset the en passant signallers
      source = chessboard.current_coordinate(self)
      chessboard.remove_piece(source)
      chessboard.add_piece(dest, promotion_piece)
    end

    def move(dest, chessboard)
      update_en_passant_status(dest, chessboard)
      self.moved = true
      super(dest, chessboard)
    end

    def en_passantable_square(chessboard)
      return unless en_passant_signal

      source = chessboard.current_coordinate(self)
      left_adjacent = coordinate_string_to_symbol(source, file_offset: -1)
      right_adjacent = coordinate_string_to_symbol(source, file_offset: 1)

      PawnEnPassant.en_passantable_square_finder([left_adjacent, right_adjacent], chessboard, @color)
    end

    def generate_possible_moves(chessboard)
      possible_moves = []
      add_moves(possible_moves, chessboard)
      possible_moves << en_passantable_square(chessboard) if @en_passant_signal

      possible_moves
    end

    private

    def update_en_passant_status(dest, chessboard)
      @en_passant_signaller = false if @en_passant_signaller
      en_passant_movement = PawnEnPassant.new(pawn: self, dest: dest, chessboard: chessboard)

      # signal_en_passant(dest, chessboard) if self_is_en_passantable?(dest, chessboard)
      en_passant_movement.signal_en_passant
      en_passant_movement.remove_en_passanted_pawn(dest, chessboard) if en_passantable_square(chessboard) == dest
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
end
