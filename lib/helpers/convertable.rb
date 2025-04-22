# frozen_string_literal: true

# methods to convert notations, symbols, and coordinates
module Convertable
  def coordinate_string_to_symbol(coordinate, file_offset: 0, rank_offset: 0)
    file = coordinate[0]
    rank = coordinate[1]

    new_file = (file.to_s.ord + file_offset).chr
    new_rank = (rank.to_s.ord + rank_offset).chr
    (new_file + new_rank).to_sym
  end
end
