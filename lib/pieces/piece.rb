# class for pieces of chess
class Piece
  attr_reader :color, :player

  def initialize(color = nil, player = nil)
    @color = color
    @player = player
  end

  def notation
    raise NotImplementedError, 'subclasses must have this method'
  end

  def symbol
    raise NotImplementedError, 'subclasses must have this method'
  end

  def calculate_square(file, rank, file_offset)
    ((file.ord + file_offset).chr + rank.to_s).to_sym
  end

  def capturable_by_white?(square)
    !square.nil? && square.color == :black
  end
end
