# class for generating, saving, loading, or getting/setting data for a valid chess position
class FEN
  def initialize
    @fen_array_strings = []
  end

  def print_fen
    fen_array_strings.join(' ')
  end

  private

  attr_accessor :fen_array_strings

  def first_field(chessboard)
    file = 'a'
    rank = 8
    space = 0
    first_field_array = []
    add_first_field_data(file, space, rank, chessboard, first_field_array)
    first_field_array = first_field_array.join('')
    # p first_field_array[-1] (remove slash later)
    fen_array_strings.push(first_field_array)
  end

  def second_field(game)
    current_color_turn = game.current_turn.color == :white ? 'w' : 'b'
    fen_array_strings.push(current_color_turn)
  end

  def add_first_field_data(file, space, rank, chessboard, first_field_array)
    until rank.zero?
      add_rank_data(file, space, rank, chessboard, first_field_array)
      rank -= 1
    end
  end

  def add_rank_data(file, space, rank, chessboard, first_field_array)
    until file == 'i'
      coordinate = (file + rank.to_s).to_sym
      piece = chessboard.find_piece_by_coordinate(coordinate)

      space = add_space_between_piece(piece, space, first_field_array)
      file = next_file(file)
    end
    first_field_array << space.to_s unless space.zero?
    first_field_array << '/'
  end

  def next_file(file)
    (file.ord + 1).chr
  end

  def add_space_between_piece(piece, space, first_field_array)
    if piece.nil?
      space + 1
    else
      first_field_array << space.to_s unless space.zero?
      first_field_array << piece.notation
      0
    end
  end
end
