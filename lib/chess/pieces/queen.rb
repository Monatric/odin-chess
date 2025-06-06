# frozen_string_literal: true

require_relative '../piece'

module Chess
  # class for the Bishop
  class Queen < Piece
    MOVE_OPTIONS = [
      # diagonal
      [-1, 1],
      [1, 1],
      [-1, -1],
      [1, -1],
      # horizontal, vertical
      [0, -1],
      [0, 1],
      [-1, 0],
      [1, 0]
    ]

    def notation
      @color == :white ? 'Q' : 'q'
    end

    def symbol
      @color == :white ? '♕' : '♛'
    end
  end
end
