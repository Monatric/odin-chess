# class for generating, saving, loading, or getting/setting data for a valid chess position
class FEN
  def initialize(game = Game.new, chessboard = Chessboard.new)
    @game = game
    @chessboard = chessboard
  end

  def generate_fen
    @fen_strings = []
    @fen_strings << first_field
    @fen_strings << second_field
    @fen_strings << third_field
    fourth_field
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
    first_field_array.join('')
  end

  def second_field
    @game.current_turn_color == :white ? 'w' : 'b'
  end

  def third_field
    field_string = []
    add_white_castling_availability(field_string)
    add_black_castling_availability(field_string)
    result = field_string.join('')
    result << '-' if result.empty?
    result
  end

  def fourth_field
    current_turn = second_field
    next_turn = current_turn == 'w' ? 'b' : 'w'
    # algorithm pseudocode:
    # get all the pawns location by white and black, store in a hash
    # Keys are the pawn objects, value is a hash with current coordinate,
    #   en_passantable that starts with false, if it moves 1 square then nil,
    #   if 2 then check if there's a black pawn beside it, if there is a black pawn then true, else nil
    # If the current turn is white, check black pieces if any object has en_passantable to true.
    #   Return that coordinate if true, else return hyphen '-'
  end

  def add_white_castling_availability(field_string)
    h1_piece = @chessboard.find_piece_by_coordinate(:h1)
    a1_piece = @chessboard.find_piece_by_coordinate(:a1)
    return if king_moved?(:white)

    field_string << 'K' if h1_piece.instance_of?(::Rook) && !h1_piece.moved
    field_string << 'Q' if a1_piece.instance_of?(::Rook) && !a1_piece.moved
    field_string
  end

  def add_black_castling_availability(field_string)
    h8_piece = @chessboard.find_piece_by_coordinate(:h8)
    a8_piece = @chessboard.find_piece_by_coordinate(:a8)
    return if king_moved?(:black)

    field_string << 'k' if h8_piece.instance_of?(::Rook) && !h8_piece.moved
    field_string << 'q' if a8_piece.instance_of?(::Rook) && !a8_piece.moved
    field_string
  end

  def king_moved?(color)
    king_coordinate = @chessboard.king_coordinate(color)
    king = @chessboard.find_piece_by_coordinate(king_coordinate)
    king.moved
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
