# frozen_string_literal: true

# require_relative '../piece'

module Chess
  # class for the pawn
  class PawnEnPassant
    extend Convertable

    def initialize(pawn: nil, dest: nil, chessboard: nil)
      @pawn = pawn
      @dest = dest
      @chessboard = chessboard
    end

    def signal_en_passant
      return unless en_passantable?

      left_adjacent = self.class.coordinate_string_to_symbol(@dest, file_offset: -1)
      right_adjacent = self.class.coordinate_string_to_symbol(@dest, file_offset: 1)

      [left_adjacent, right_adjacent].each do |adjacent|
        next unless @chessboard.coordinate_exist?(adjacent)

        piece = @chessboard.find_piece_by_coordinate(adjacent)
        piece.en_passant_signal = true if piece.respond_to?(:en_passant_signal)
        @pawn.en_passant_signaller = true
      end
    end

    def remove_en_passanted_pawn(dest, chessboard)
      # if dest is 3, this means white pawn is captured at fourth rank
      # else it would be 6, captured black pawn at fifth rank
      rank = dest[0]
      en_passanted_color = (rank == '6' ? :black : :white)
      rank_offset = (en_passanted_color == :white ? -1 : 1)
      opponent_pawn_coordinate = self.class.coordinate_string_to_symbol(dest, rank_offset: rank_offset)
      chessboard.remove_piece(opponent_pawn_coordinate)
    end

    def self.en_passantable_square_finder(adjacent_arr, chessboard, color)
      coordinate_behind_pawn = nil
      adjacent_arr.each do |adjacent|
        # next unless chessboard.coordinate_exist?(adjacent)

        piece = chessboard.find_piece_by_coordinate(adjacent)

        next unless piece.respond_to?(:en_passant_signal) && piece.en_passant_signaller

        # imagine this happening as the current player. The current player, say a white and its pawn, will
        # look for the square behind the black pawny
        rank_behind_white_pawn = -1
        rank_behind_black_pawn = 1
        rank_offset = (color == :white ? rank_behind_black_pawn : rank_behind_white_pawn)
        coordinate_behind_pawn = coordinate_string_to_symbol(adjacent, rank_offset: rank_offset)
      end
      coordinate_behind_pawn
    end

    private

    def en_passantable?
      source = @chessboard.current_coordinate(@pawn)
      if source[1] == '2' && @dest[1] == '4'
        adjacent_is_opponent_pawn?(:black)
      elsif source[1] == '7' && @dest[1] == '5'
        adjacent_is_opponent_pawn?(:white)
      end
    end

    def adjacent_is_opponent_pawn?(opponent_color)
      left_adjacent = self.class.coordinate_string_to_symbol(@dest, file_offset: -1)
      right_adjacent = self.class.coordinate_string_to_symbol(@dest, file_offset: 1)

      result = false
      [left_adjacent, right_adjacent].each do |adjacent|
        next unless @chessboard.coordinate_exist?(adjacent)

        piece = @chessboard.find_piece_by_coordinate(adjacent)
        result = piece&.color == opponent_color
      end
      result
    end
  end
end
