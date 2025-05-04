# frozen_string_literal: true

module Chess
  # class for analyzing threats and move legalities
  class ThreatAnalyzer
    def self.covered_squares_of_color(color, chessboard)
      squares_with_pieces = chessboard.find_squares_with_pieces_by_color(color)
      squares_with_pieces.map do |_, info|
        info[:piece].possible_moves(chessboard)
      end.flatten
    end

    def self.legal_squares_of_color(color, chessboard)
      # color parameter is usually the current turn. Might be confusing what it means by
      # current_turn in the variable. Not sure what's the best design here.
      king_coordinate = chessboard.king_coordinate(color)
      opponent_covered_squares = covered_squares_of_color(color == :white ? :black : :white, chessboard)
      current_turn_covered_squares = covered_squares_of_color(color, chessboard)
      current_turn_covered_squares.map do |current_turn_square|
        current_turn_square unless current_turn_square == opponent_covered_squares.any?(king_coordinate)
      end
    end

    def self.in_check?(color, chessboard)
      # color parameter is usually the current turn. Might be confusing what it means by
      # current_turn in the variable. Not sure what's the best design here.
      # Use chessboard parameter to validate duplicate board or real board
      king_coordinate = chessboard.king_coordinate(color)
      opponent_covered_squares = covered_squares_of_color(color == :white ? :black : :white, chessboard)
      opponent_covered_squares.any? { |coordinate| coordinate == king_coordinate }
    end

    def self.move_avoids_check?(source, dest, game)
      current_turn_color = game.current_turn_color
      chessboard = game.chessboard
      board_duplicate = Marshal.load(Marshal.dump(chessboard))
      game.move_piece(source, dest, board_duplicate)

      # if the king is still in check (true), then move does not avoid the check (false)
      in_check?(current_turn_color, board_duplicate) ? false : true
    end
  end
end
