# class for generating, saving, loading, or getting/setting data for a valid chess position
class FEN
  def initialize(game = Game.new, chessboard = Chessboard.new)
    @game = game
    @chessboard = chessboard
  end

  def generate_fen
    @fen_strings = []
    first_field
    second_field
    third_field
    @fen_strings.join(' ')
  end

  private

  attr_accessor :fen_strings

  def first_field
    file = 'a'
    rank = 8
    space = 0
    first_field_array = []
    add_first_field_data(file, space, rank, first_field_array)
    first_field_array = first_field_array.join('')
    fen_strings.push(first_field_array)
  end

  def second_field
    current_color_turn = @game.current_turn.color == :white ? 'w' : 'b'
    fen_strings.push(current_color_turn)
  end

  def third_field
    field_string = []
    add_white_castling_availability(field_string)
    add_black_castling_availability(field_string)
    result = field_string.join('')
    result << '-' if result.empty?
    fen_strings.push(result)
  end

  def add_white_castling_availability(field_string)
    h1_piece = @chessboard.find_piece_by_coordinate(:h1)
    a1_piece = @chessboard.find_piece_by_coordinate(:a1)
    e1_piece = @chessboard.find_piece_by_coordinate(:e1)
    return unless e1_piece.instance_of?(::King) # && e1_piece.moved

    field_string << 'K' if h1_piece.instance_of?(::Rook) && !h1_piece.moved
    field_string << 'Q' if a1_piece.instance_of?(::Rook) && !a1_piece.moved
    field_string
  end

  def add_black_castling_availability(field_string)
    h8_piece = @chessboard.find_piece_by_coordinate(:h8)
    a8_piece = @chessboard.find_piece_by_coordinate(:a8)
    e8_piece = @chessboard.find_piece_by_coordinate(:e8)
    return unless e8_piece.instance_of?(::King) # && e8_piece.moved

    field_string << 'k' if h8_piece.instance_of?(::Rook) && !h8_piece.moved
    field_string << 'q' if a8_piece.instance_of?(::Rook) && !a8_piece.moved
    field_string
  end

  def add_first_field_data(file, space, rank, first_field_array)
    until rank.zero?
      add_rank_data(file, space, rank, first_field_array)
      rank -= 1
    end
  end

  def add_rank_data(file, space, rank, first_field_array)
    until file == 'i'
      coordinate = (file + rank.to_s).to_sym
      piece = @chessboard.find_piece_by_coordinate(coordinate)

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
