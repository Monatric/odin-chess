# frozen_string_literal: true

module Chess
  # class for generating, saving, loading, or getting/setting data for a valid chess position
  class FEN
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
      add_white_castling_availability(field_string)
      add_black_castling_availability(field_string)
      result = field_string.join('')
      result << '-' if result.empty?
      result
    end

    def en_passant_field
      no_en_passant_square = '-'
      result = nil
      # check all files of the given rank to find out if a pawn is en passantable
      (FILE_ORDINALS[:first]..'h').each do |file|
        6.downto(3).each do |rank|
          coordinate = "#{file}#{rank}".to_sym
          # coordinate_file = coordinate[0]
          piece = @chessboard.find_piece_by_coordinate(coordinate)
          en_passantable_square = piece&.en_passantable_square(@chessboard) if piece.respond_to?(:en_passant)
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
end
