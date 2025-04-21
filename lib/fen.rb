# frozen_string_literal: true

# class for generating, saving, loading, or getting/setting data for a valid chess position
class FEN
  def initialize(game = Game.new, chessboard = Chessboard.new, halfmove_clock = HalfmoveClockField.new(chessboard))
    @game = game
    @chessboard = chessboard
    @halfmove_clock = halfmove_clock
  end

  def generate_fen
    @fen_strings = []
    @fen_strings << PiecePlacementField.generate(@chessboard)
    @fen_strings << ActiveColorField.generate(@game)
    @fen_strings << CastlingAvailabilityField.generate(@chessboard)
    @fen_strings << EnPassantField.generate(@chessboard)
    @fen_strings << @halfmove_clock.generate
    @fen_strings.join(' ')
  end

  private

  attr_accessor :fen_strings
end
