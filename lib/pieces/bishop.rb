# frozen_string_literal: true

require_relative 'piece'

# class for the Bishop
class Bishop < Piece
  MOVE_OPTIONS = [
    [-1, 1],
    [1, 1],
    [-1, -1],
    [1, -1]
  ]

  def notation
    @color == :white ? 'B' : 'b'
  end

  def symbol
    @color == :white ? '♗' : '♝'
  end
end
