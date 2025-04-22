# frozen_string_literal: true

require_relative '../../piece'

module Chess
  # class for the Bishop
  class KingCastling
    def self.add_castling_moves(possible_moves, chessboard, king)
      # check if king has moved
      return if king.moved

      valid_castle_coordinates(chessboard, king).each { |coordinate| possible_moves << coordinate }
    end

    # private

    def self.valid_castle_coordinates(chessboard, king) # rubocop:disable Metrics/MethodLength
      castle_paths = {
        white: {
          g1: %i[f1 g1],
          c1: %i[d1 c1 b1]
        },
        black: {
          g8: %i[f8 g8],
          c8: %i[d8 c8 b8]
        }
      }
      results = []
      color = king.color
      castle_paths[color].each_pair do |castle_coordinate, path|
        next if rook_moved?(castle_coordinate)

        results << castle_coordinate if castle_path_empty?(path, chessboard)
      end
      results
    end

    def self.rook_moved?(castle_coordinate)
      rook_coordinate = ROOK_COORDINATES_AFTER_CASTLING[castle_coordinate]
      # false if the chosen castle_coordinate is not a rook
      return false unless rook_coordinate.is_a?(Rook)

      # if the rook has moved
      rook_coordinate.moved
    end

    def self.castle_path_empty?(path, chessboard)
      path.all? do |coordinate|
        chessboard.find_piece_by_coordinate(coordinate).nil?
      end
    end
  end
end
