# frozen_string_literal: true

# methods to convert notations, symbols, and coordinates
module Convertable
  def notation_to_piece(notation) # rubocop:disable Metrics/MethodLength
    piece_notation_objects = {
      'r' => Chess::Rook.new(:black),
      'n' => Chess::Knight.new(:black),
      'b' => Chess::Bishop.new(:black),
      'q' => Chess::Queen.new(:black),
      'k' => Chess::King.new(:black),
      'p' => Chess::Pawn.new(:black),
      'R' => Chess::Rook.new(:white),
      'N' => Chess::Knight.new(:white),
      'B' => Chess::Bishop.new(:white),
      'Q' => Chess::Queen.new(:white),
      'K' => Chess::King.new(:white),
      'P' => Chess::Pawn.new(:white)
    }
    piece_notation_objects[notation]
  end

  def coordinate_string_to_symbol(coordinate, file_offset: 0, rank_offset: 0)
    return ArgumentError, 'coordinate should be a symbol' unless coordinate.is_a? Symbol

    file = coordinate[0]
    rank = coordinate[1]

    new_file = (file.to_s.ord + file_offset).chr
    new_rank = (rank.to_s.ord + rank_offset).chr
    (new_file + new_rank).to_sym
  end
end
