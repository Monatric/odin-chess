# frozen_string_literal: true

module Chess
  # to interact or generate related to movements in the game
  class MoveList
    def self.generate_list_from(piece, chessboard)
      piece.generate_possible_moves(chessboard)
    end

    def self.legal_squares_of_color(color, chessboard, game)
      # color parameter is usually the current turn. Might be confusing what it means by
      # current_turn in the variable. Not sure what's the best design here.
      legal_moves = []
      current_turn_covered_squares = covered_squares_of_color_with_source(color, chessboard)
      current_turn_covered_squares.map do |source, dests|
        dests.each do |dest|
          legal_moves << dest if ThreatAnalyzer.move_avoids_check?(source, dest, game)
        end
      end
      legal_moves
    end

    def self.covered_squares_of_color(color, chessboard)
      squares_with_pieces = chessboard.find_squares_with_pieces_by_color(color)
      squares_with_pieces.map do |_, info|
        # [chessboard.find_coordinate_by_position(info[:position]),
        info[:piece].generate_possible_moves(chessboard)
      end.flatten
    end

    def self.covered_squares_of_color_with_source(color, chessboard)
      squares_with_pieces = chessboard.find_squares_with_pieces_by_color(color)
      hash_of_piece_possible_moves = {}
      squares_with_pieces.each do |source, info|
        piece_moves = info[:piece].generate_possible_moves(chessboard)
        hash_of_piece_possible_moves[source] = piece_moves
      end
      hash_of_piece_possible_moves
    end
  end
end
