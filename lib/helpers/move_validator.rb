# frozen_string_literal: true

module Chess
  # This class helps validating a player's move which consists a lot of factors such as
  # format and moveability.
  class MoveValidator
    def initialize(move:, game: Game.new)
      @move = move
      @game = game
      @chessboard = game.chessboard
      @source = move.slice(0, 2).to_sym
      @dest = move.slice(2, 3).to_sym
    end

    def valid_move?
      valid_format? && valid_positions? &&
        piece_belongs_to_current_player? && piece_can_move_to? &&
        castling_attempt? && valid_castling? &&
        ThreatAnalyzer.move_avoids_check?(@source, @dest, @game)
    end

    def valid_format?
      @move.length == 4
    end

    def valid_positions?
      @game.chessboard.valid_source_and_dest?(@source, @dest)
    end

    def castling_attempt?
      %i[e1g1 e1c1 e8g8 e8c8].include?("#{@source}#{@dest}".to_sym)
    end

    def valid_castling?
      dest_to_rook_coord = { c1: :a1, g1: :h1, c8: :a8, g8: :h8 }
      rook_coord = dest_to_rook_coord[@dest]
      castling_first_square = { c1: :d1, g1: :f1 }
      first_square_before_castling = castling_first_square[@dest]
      check_result = ThreatAnalyzer.move_avoids_check?(@source, first_square_before_castling, @game)

      king = chessboard.find_piece_by_coordinate(@source)
      rook = chessboard.find_piece_by_coordinate(rook_coord)
      king.castleable? && rook&.castleable? && check_result
    end

    def piece_belongs_to_current_player?
      piece = @chessboard.find_piece_by_coordinate(@source)
      piece && piece.color == @game.current_turn_color
    end

    def piece_can_move_to?
      piece = @chessboard.find_piece_by_coordinate(@source)
      piece && piece.can_move_to?(dest, @chessboard)
    end
  end
end
