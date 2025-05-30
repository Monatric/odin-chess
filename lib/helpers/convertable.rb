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

  # NOTE: just realized now the method name is not exactly what it is. It should be
  # named into something like coordinate_offset_converter but it's a hassle to refactor now
  # as many objects and tests use this name
  def coordinate_string_to_symbol(coordinate, file_offset: 0, rank_offset: 0)
    return 'invalid coordinate' unless valid_coordinate?(coordinate)

    file = coordinate[0]
    rank = coordinate[1]

    new_file = (file.to_s.ord + file_offset).chr
    new_rank = (rank.to_s.ord + rank_offset).chr
    (new_file + new_rank).to_sym
  end

  private

  def valid_coordinate?(coordinate)
    return false unless coordinate.is_a?(Symbol) && coordinate.length == 2

    file = coordinate[0]
    rank = coordinate[1]

    file_dictionary = 'abcdfegh'.split('')
    rank_dictionary = '12345678'.split('')
    file_dictionary.include?(file) && rank_dictionary.include?(rank)
  end
end
