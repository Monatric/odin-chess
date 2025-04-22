# frozen_string_literal: true

require_relative '../piece'

module Chess
  # class for the Rook
  class Rook < Piece
    attr_accessor :moved

    MOVE_OPTIONS = [
      [0, -1],
      [0, 1],
      [-1, 0],
      [1, 0]
    ]

    def initialize(color, moved = false)
      super(color)
      @moved = moved
    end

    def move(dest, chessboard)
      self.moved = true
      super(dest, chessboard)
    end

    def notation
      @color == :white ? 'R' : 'r'
    end

    def symbol
      @color == :white ? '♖' : '♜'
    end

    # def castleable?
    #   !@moved
    # end
  end
end
