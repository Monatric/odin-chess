# frozen_string_literal: true

module Chess
  # This tracks the threefold repetition, storing the FEN fields that are necessary to scan for draw
  class ThreefoldRepetitionTracker
    def initialize(fen: FEN.new, repetition_tracker: {})
      @fen = fen
      @repetition_tracker = repetition_tracker
    end

    def trim_fen(notation)
      piece_placement_field = FEN.parse_piece_placement_field(notation)
      active_color_field = FEN.parse_active_color_field(notation)
      castling_availability_field = FEN.parse_castling_availability_field(notation)
      en_passant_field = FEN.parse_en_passant_field(notation)

      "#{piece_placement_field} #{active_color_field} #{castling_availability_field} #{en_passant_field}"
    end

    def update
      notation = @fen.notation
      four_fields_fen = trim_fen(notation)
      if @repetition_tracker.include?(four_fields_fen)
        @repetition_tracker[four_fields_fen] += 1
      else
        @repetition_tracker[four_fields_fen] = 1
      end
    end

    def threefold_repetition?
      three_repetitions = 3
      @repetition_tracker.values.include?(three_repetitions)
    end

    private

    attr_accessor :fen, :repetition_tracker, :notation
  end
end
