# class for generating, saving, loading, or getting/setting data for a valid chess position
class FEN
  def initialize
    @fen_array_strings = []
  end

  def print_fen(chessboard, game)
    first_field(chessboard)
    second_field(game)
    third_field(chessboard)
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

  def third_field(chessboard)
    field_string = []
    add_white_castling_availability(chessboard, field_string)
    add_black_castling_availability(chessboard, field_string)
    result = field_string.join('')
    result << '-' if result.empty?
    fen_array_strings.push(result)
  end

  def add_white_castling_availability(chessboard, field_string)
    h1_piece = chessboard.find_piece_by_coordinate(:h1)
    a1_piece = chessboard.find_piece_by_coordinate(:a1)
    e1_piece = chessboard.find_piece_by_coordinate(:e1)
    return unless e1_piece.instance_of?(::King) # && e1_piece.moved

    field_string << 'K' if h1_piece.instance_of?(::Rook) && !h1_piece.moved
    field_string << 'Q' if a1_piece.instance_of?(::Rook) && !a1_piece.moved
    field_string
  end

  def add_black_castling_availability(chessboard, field_string)
    h8_piece = chessboard.find_piece_by_coordinate(:h8)
    a8_piece = chessboard.find_piece_by_coordinate(:a8)
    e8_piece = chessboard.find_piece_by_coordinate(:e8)
    return unless e8_piece.instance_of?(::King) # && e8_piece.moved

    field_string << 'k' if h8_piece.instance_of?(::Rook) && !h8_piece.moved
    field_string << 'q' if a8_piece.instance_of?(::Rook) && !a8_piece.moved
    field_string
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
