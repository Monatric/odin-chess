# frozen_string_literal: true

module Chess
  # to interact or generate related to movements in the game
  class Move
    def self.generate_list_from(piece, chessboard)
      piece.generate_possible_moves(chessboard)
    end
  end
end
