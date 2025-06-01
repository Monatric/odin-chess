# frozen_string_literal: true

require_relative '../helpers/move_list'

module Chess
  # class for analyzing threats and move legalities
  class ThreatAnalyzer
    def self.checkmate?(color, chessboard, game)
      MoveList.legal_squares_of_color(color, chessboard, game).empty? && in_check?(color, chessboard)
    end

    def self.stalemate?(color, chessboard, game)
      MoveList.legal_squares_of_color(color, chessboard, game).empty? && !in_check?(color, chessboard)
    end

    def self.in_check?(color, chessboard)
      # color parameter is usually the current turn. Might be confusing what it means by
      # current_turn in the variable. Not sure what's the best design here.
      # Use chessboard parameter to validate duplicate board or real board
      king_coordinate = chessboard.king_coordinate(color)
      opponent_color =  color == :white ? :black : :white
      opponent_covered_squares = MoveList.covered_squares_of_color(opponent_color, chessboard)
      opponent_covered_squares.any? { |coordinate| coordinate == king_coordinate }
    end

    def self.move_avoids_check?(source, dest, game)
      current_turn_color = game.current_turn_color
      chessboard = game.chessboard
      board_duplicate = Marshal.load(Marshal.dump(chessboard))
      game.move_piece(source, dest, board_duplicate, dup: true)

      # if the king is still in check (true), then move does not avoid the check (false)
      in_check?(current_turn_color, board_duplicate) ? false : true
    end
  end
end
