# frozen_string_literal: true

# module to help methods for navigating the board
module ChessboardNavigatable
  # from a8 to h8, then a7 to h8...until a1 to h1
  def coordinate_iterator(file: 'a', rank: nil, &block)
    until file == 'i'
      coordinate = "#{file}#{rank}".to_sym
      file = (file.ord + 1).chr
      # unless rank.nil?
      #   rank += 1 if rank == '0'
      #   rank = rank.to_i - 1 if rank == '8'
      # end
      yield(coordinate)
      block.call
    end
  end
end
