# frozen_string_literal: true

module Chess
  # class for generating the third field of FEN, responsible for showing which sides are able to perform castling
  class CastlingAvailabilityField
    CASTLING_DICTIONARY = {
      white: {
        king: { coordinate: :e1, notation: 'K' },
        a_rook: { coordinate: :a1 },
        h_rook: { coordinate: :h1 },
        rook: { coordinate: %i[a1 h1] },
        queen: { notation: 'Q' }
      },
      black: {
        king: { coordinate: :e8, notation: 'k' },
        a_rook: { coordinate: :a8 },
        h_rook: { coordinate: :h8 },
        rook: { coordinate: %i[a8 h8] },
        queen: { notation: 'q' }
      }
    }.freeze

    def self.generate(chessboard)
      field_string = []
      add_castling_availability(field_string, chessboard)
      result = field_string.join('')
      result << '-' if result.empty?
      result
    end

    def self.add_castling_availability(field_string, chessboard)
      CASTLING_DICTIONARY.map do |_color, pieces|
        king_coordinate = pieces[:king][:coordinate]
        king = chessboard.find_piece_by_coordinate(king_coordinate)
        next unless king&.castleable?

        a_rook_coordinate = pieces[:a_rook][:coordinate]
        a_rook = chessboard.find_piece_by_coordinate(a_rook_coordinate)

        h_rook_coordinate = pieces[:h_rook][:coordinate]
        h_rook = chessboard.find_piece_by_coordinate(h_rook_coordinate)

        field_string << pieces[:king][:notation] if h_rook&.castleable?
        field_string << pieces[:queen][:notation] if a_rook&.castleable?
      end
    end
  end
end
