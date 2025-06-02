# frozen_string_literal: true

module Chess
  # class for generating, saving, loading, or getting/setting data for a valid chess position
  class FEN
    attr_accessor :notation

    def initialize(game: Game.new,
                   chessboard: Chessboard.new,
                   halfmove_clock: HalfmoveClockField.new(chessboard),
                   fullmove_number: FullmoveNumberField.new(game),
                   notation: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w KQkq - 0 1')
      @game = game
      @chessboard = chessboard
      @halfmove_clock = halfmove_clock
      @fullmove_number = fullmove_number
      @notation = notation
      generate_fen
    end

    def self.parse_piece_placement_field(fen)
      fen.split(' ')[0]
    end

    def self.parse_active_color_field(fen)
      fen.split(' ')[1]
    end

    def self.parse_castling_availability_field(fen)
      fen.split(' ')[2]
    end

    def self.parse_en_passant_field(fen)
      fen.split(' ')[3]
    end

    def self.parse_halfmove_clock_field(fen)
      fen.notation.split(' ')[4]
    end

    def self.parse_fullmove_number_field(fen)
      fen.split(' ')[5]
    end

    def generate_fen
      fen_strings = []
      fen_strings << PiecePlacementField.generate(@chessboard)
      fen_strings << ActiveColorField.generate(@game)
      fen_strings << CastlingAvailabilityField.generate(@chessboard)
      fen_strings << EnPassantField.generate(@chessboard)
      fen_strings << @halfmove_clock.generate
      fen_strings << @fullmove_number.generate

      @notation = fen_strings.join(' ')
    end
  end
end
