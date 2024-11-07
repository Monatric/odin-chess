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
    add_first_field_data(file, space, rank, chessboard)
  end

  private

  def add_first_field_data(file, space, rank, chessboard)
    until rank.zero?
      add_rank_data(file, space, rank, chessboard)
      rank -= 1
    end
  end

  def add_rank_data(file, space, rank, chessboard)
    until file == 'i'
      coordinate = (file + rank.to_s).to_sym
      piece = chessboard.find_piece_by_coordinate(coordinate)

      space = update_fen_string(piece, space)
      file = next_file(file)
    end
    fen_string << space.to_s unless space.zero?
    fen_string << '/'
  end

  def next_file(file)
    (file.ord + 1).chr
  end

  def update_fen_string(piece, space)
    if piece.nil?
      space + 1
    else
      fen_string << space.to_s unless space.zero?
      fen_string << piece.notation
      0
    end
  end
end
