# frozen_string_literal: true

module Chess
  # to interact or generate related to movements in the game
  class MoveList
    def self.generate_list_from(piece, chessboard)
      piece.generate_possible_moves(chessboard)
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

    def self.covered_squares_of_color(color, chessboard)
      squares_with_pieces = chessboard.find_squares_with_pieces_by_color(color)
      squares_with_pieces.map do |_, info|
        info[:piece].generate_possible_moves(chessboard)
      end.flatten
    end
  end
end
