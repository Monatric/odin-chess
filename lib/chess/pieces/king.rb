# frozen_string_literal: true

require_relative '../piece'
require_relative 'advanced_piece_movement/king_castling'

module Chess
  ROOK_COORDINATES_AFTER_CASTLING = {
    g1: %i[h1 f1],
    c1: %i[a1 d1],
    g8: %i[h8 f8],
    c8: %i[a8 d8]
  }.freeze
  # class for the King piece
  class King < Piece
    KING_OPTIONS = [
      [0, 1], # forward
      [1, 1], # upright
      [1, 0], # right
      [1, -1], # downright
      [0, -1], # down
      [-1, -1], # downleft
      [-1, 0], # left
      [-1, 1] # upleft
    ]

    attr_accessor :moved

    def initialize(color, moved = false)
      super(color)
      @moved = moved
    end

    def move(dest, chessboard)
      self.moved = true
      super(dest, chessboard)
    end

    def castle(dest, chessboard)
      self.moved = true

      source = chessboard.current_coordinate(self)
      castling_king_move(source, dest, chessboard)
      castling_rook_move(dest, chessboard)
    end

    def notation
      @color == :white ? 'K' : 'k'
    end

    def symbol
      @color == :white ? '♔' : '♚'
    end

    private

    def castling_king_move(source, dest, chessboard)
      chessboard.remove_piece(source)
      chessboard.add_piece(dest, self)
    end

    def castling_rook_move(dest, chessboard)
      rook_coordinate_after_castling = ROOK_COORDINATES_AFTER_CASTLING[dest][0]
      rook = chessboard.find_piece_by_coordinate(rook_coordinate_after_castling)

      rook_coordinate = chessboard.current_coordinate(rook)
      chessboard.remove_piece(rook_coordinate)

      rook_new_coordinate = ROOK_COORDINATES_AFTER_CASTLING[dest][1]
      chessboard.add_piece(rook_new_coordinate, rook)
    end

    def add_moves(file, rank, possible_moves, chessboard)
      add_basic_moves(file, rank, possible_moves, chessboard)
      KingCastling.add_castling_moves(possible_moves, chessboard, self)
    end

    def add_basic_moves(file, rank, possible_moves, chessboard)
      KING_OPTIONS.each do |option|
        position = option[0] + file, option[1] + rank
        coordinate = chessboard.find_coordinate_by_position(position)
        next if coordinate.nil?

        if chessboard.find_piece_by_coordinate(coordinate).nil?
          possible_moves << coordinate
        elsif chessboard.find_piece_by_coordinate(coordinate).color != color
          possible_moves << coordinate
        end
      end
    end
  end
end
