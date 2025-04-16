# frozen_string_literal: true

# class for generating, saving, loading, or getting/setting data for a valid chess position
class FEN
  CASTLING_DICTIONARY = {
    white: {
      king: { coordinate: :e1, notation: 'K' },
      a_rook: { coordinate: :a1 },
      h_rook: { coordinate: :h1 },
      rook: { coordinate: %i[a1 h1] },
      queen: { notation: 'Q' }
    },
    black: {
      king: { coordinate: :e8, notation: 'k' },
      a_rook: { coordinate: :a8 },
      h_rook: { coordinate: :h8 },
      rook: { coordinate: %i[a8 h8] },
      queen: { notation: 'q' }
    }
  }.freeze

  def initialize(game = Game.new, chessboard = Chessboard.new)
    @game = game
    @chessboard = chessboard
  end

  def generate_fen
    @fen_strings = []
    @fen_strings << piece_placement_field
    @fen_strings << active_color_field
    @fen_strings << castling_availability_field
    @fen_strings << en_passant_field
    # @fen_strings << fifth_field
    @fen_strings.join(' ')
  end

  private

  attr_accessor :fen_strings

  def piece_placement_field
    space = 0
    piece_placement_field_array = []
    add_piece_placement_field(space, piece_placement_field_array)
    piece_placement_field_array.join('')
  end

  def active_color_field
    @game.current_turn_color == :white ? 'w' : 'b'
  end

  def castling_availability_field
    field_string = []
    add_castling_availability(field_string)
    result = field_string.join('')
    result << '-' if result.empty?
    result
  end

  def en_passant_field
    no_en_passant_square = '-'
    result = nil
    # check all files of the given rank to find out if a pawn is en passantable
    ('a'..'h').each do |file|
      5.downto(4).each do |rank|
        coordinate = "#{file}#{rank}".to_sym
        piece = @chessboard.find_piece_by_coordinate(coordinate)
        en_passantable_square = piece&.en_passantable_square(@chessboard) if piece.respond_to?(:en_passant_signal)
        result = en_passantable_square unless en_passantable_square.nil?
      end
    end
    result = (result.nil? ? no_en_passant_square : result) # default hyphen, no en passant square
  end

  def fifth_field
    coordinate_iterator(file: 'a', rank: '8') do |coordinate|
      # p coordinate
      @chessboard.find_piece_by_coordinate(coordinate)
    end
  end

  def add_castling_availability(field_string)
    CASTLING_DICTIONARY.map do |_color, pieces|
      king_coordinate = pieces[:king][:coordinate]
      king = @chessboard.find_piece_by_coordinate(king_coordinate)
      next unless king&.castleable?

      a_rook_coordinate = pieces[:a_rook][:coordinate]
      a_rook = @chessboard.find_piece_by_coordinate(a_rook_coordinate)

      h_rook_coordinate = pieces[:h_rook][:coordinate]
      h_rook = @chessboard.find_piece_by_coordinate(h_rook_coordinate)

      field_string << pieces[:king][:notation] if h_rook&.castleable?
      field_string << pieces[:queen][:notation] if a_rook&.castleable?
    end
  end

  def add_piece_placement_field(space, piece_placement_field_array)
    8.downto(1) do |rank|
      ('a'..'h').each do |file|
        coordinate = (file + rank.to_s).to_sym
        piece = @chessboard.find_piece_by_coordinate(coordinate)

        space = add_space_between_piece(piece, space, piece_placement_field_array)
      end
      piece_placement_field_array << space.to_s unless space.zero?
      piece_placement_field_array << '/'
      space = 0
    end
  end

  def add_space_between_piece(piece, space, piece_placement_field_array)
    if piece.nil?
      space + 1
    else
      piece_placement_field_array << space.to_s unless space.zero?
      piece_placement_field_array << piece.notation
      0
    end
  end
end
