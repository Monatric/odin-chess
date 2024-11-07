# class for generating, saving, loading, or getting/setting data for a valid chess position
class FEN
  attr_accessor :fen_string

  def initialize
    @fen_string = ''
  end

  def first_field(chessboard)
    file = 'a'
    rank = 8
    space = 0
    until rank.zero?
      coordinate = (file + rank.to_s).to_sym
      piece = chessboard.find_piece_by_coordinate(coordinate)
      space += 1 if piece.nil?
      fen_string << space.to_s unless piece.nil? || space.zero?

      unless piece.nil?
        fen_string << piece.notation
        space = 0
      end

      file = (file.ord + 1).chr

      next unless file == 'i'

      fen_string << space.to_s unless space.zero?
      fen_string << '/'
      file = 'a'
      space = 0
      rank -= 1
    end
  end

  def move_row_first_field_generator(file, space, rank)
  end
end
