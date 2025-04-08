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
    @fen_strings << fourth_field
    # @fen_strings << fifth_field
    @fen_strings.join(' ')
  end

  private

  attr_accessor :fen_strings

  def first_field
    space = 0
    first_field_array = []
    add_first_field_data(space, first_field_array)
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
    # if current color is white, it means a turn has passed without the opponent capturing the en passant, thus a reset
    rank = (second_field == 'w' ? '5' : '4')
    ('a'..'h').each do |file|
      coordinate = "#{file}#{rank}".to_sym
      piece = @chessboard.find_piece_by_coordinate(coordinate)
      if piece&.en_passant == true
        rank_behind_pawn = (rank == '5' ? '6' : '3')
        return (coordinate[0] + rank_behind_pawn)
      end
    end
    '-' # return hyphen if nothing's en passantable
  end

  def fifth_field
    coordinate_iterator(file: 'a', rank: '8') do |coordinate|
      # p coordinate
      @chessboard.find_piece_by_coordinate(coordinate)
    end
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

  def add_first_field_data(space, first_field_array)
    8.downto(1) do |rank|
      ('a'..'h').each do |file|
        coordinate = (file + rank.to_s).to_sym
        piece = @chessboard.find_piece_by_coordinate(coordinate)

        space = add_space_between_piece(piece, space, first_field_array)
      end
      first_field_array << space.to_s unless space.zero?
      first_field_array << '/'
      space = 0
    end
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
