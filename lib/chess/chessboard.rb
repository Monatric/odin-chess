# frozen_string_literal: true

require_relative '../displayable'
require_relative 'pieces/king'

module Chess
  # class for the chess board and its states
  class Chessboard
    include Convertable
    include Displayable

    def initialize(board: create, fen_string: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w KQkq - 0 1')
      @board = board
      assemble(fen_string)
    end

    def self.from_fen(fen_string)
      # fen_string = FEN.parse_piece_placement_field(fen_string)
      new(fen_string: fen_string)
    end

    def create
      cells = {}
      rank_counter = 0
      ('a'..'h').each do |file|
        (1..8).each do |rank|
          notation = file + rank.to_s
          cells[notation.to_sym] = { piece: nil, position: [rank_counter, rank - 1] }
        end
        rank_counter += 1
      end
      cells
    end

    def show
      display_board(@board)
    end

    def add_piece(coordinate, piece)
      board[coordinate][:piece] = piece
    end

    def remove_piece(coordinate)
      board[coordinate][:piece] = nil
    end

    def coordinate_exist?(coordinate)
      board.key?(coordinate)
    end

    def valid_source_and_dest?(source, dest)
      coordinate_exist?(source) && coordinate_exist?(dest)
    end

    def assemble(fen_string)
      piece_placement_field = FEN.parse_piece_placement_field(fen_string)
      rank_data = piece_placement_field.split('/')

      rank_data.each_with_index do |piece_placement_data, current_rank|
        rank = (RANK_ORDINALS[:eighth] - current_rank).to_s
        add_pieces_by_piece_placement_data(FILE_ORDINALS[:first], rank, piece_placement_data, fen_string)
      end

      modify_en_passant_signal(fen_string)
    end

    def find_piece_by_coordinate(coordinate)
      return nil unless coordinate_exist?(coordinate)

      board[coordinate][:piece]
    end

    def find_piece_by_position(position)
      coordinate = find_coordinate_by_position(position)
      board[coordinate][:piece]
    end

    def find_coordinate_by_position(position)
      col = position[0]
      row = position[1] + 1 # add 1 because of indexing
      file = 'a'
      coordinate = ((file.ord + col).chr + row.to_s).to_sym
      board.key?(coordinate) ? coordinate : nil
    end

    def current_coordinate(piece)
      board.select do |coordinate, data|
        return coordinate if data[:piece] == piece
      end
      nil
    end

    def current_position(piece)
      board.select do |_, data|
        return data[:position] if data[:piece] == piece
      end
      nil
    end

    def king_coordinate(color)
      board.select do |_, value|
        value[:piece].is_a?(King) && value[:piece].color == color
      end.keys.first
    end

    def find_squares_with_pieces_by_color(color)
      board.select do |_, info|
        !info[:piece].nil? && info[:piece].color == color
      end
    end

    private

    attr_reader :board

    def add_pieces_by_piece_placement_data(first_file, rank, piece_placement_data, fen_string)
      # castling_availability = FEN.parse_castling_availability_field(fen_string).split('')
      space = 0
      # convert to chars to get individual chars into array
      piece_placement_data.chars.each do |notation|
        file = (first_file.ord + space).chr
        coordinate = (file + rank).to_sym

        # if the char is a number, this must be space. Use it as how many spaces (nil) must be placed
        if notation.match(/[0-9]/)
          add_nil_pieces(file, rank, coordinate, notation)
          space += notation.to_i
        else
          piece = notation_to_piece(notation)
          @board[coordinate][:piece] = piece

          king_and_rook_notations = (piece.color == :white ? %w[K R] : %w[k r])
          modify_castling_rights(notation, coordinate, fen_string, piece) if king_and_rook_notations.include?(notation)
          space += 1
        end
      end
    end

    def modify_en_passant_signal(fen_string)
      en_passantable_square = FEN.parse_en_passant_field(fen_string)
      return if en_passantable_square == '-' # hyphen means no en passant

      en_passantable_square_rank = en_passantable_square[1].to_i
      en_passantable_square_file = en_passantable_square[0]
      rank_offset = (en_passantable_square_rank == RANK_ORDINALS[:sixth] ? -1 : 1)

      # add/subtract the rank of en passant field and turn into string
      rank = (en_passantable_square_rank + rank_offset).to_s
      en_passantable_pawn_coordinate = (en_passantable_square_file + rank).to_sym
      piece = find_piece_by_coordinate(en_passantable_pawn_coordinate)

      en_passant_movement = PawnEnPassant.new(pawn: piece, dest: en_passantable_pawn_coordinate, chessboard: self)

      source_offset = (piece.color == :white ? -2 : 2)
      source = coordinate_string_to_symbol(en_passantable_pawn_coordinate, rank_offset: source_offset)
      en_passant_movement.signal_en_passant(source)
    end

    def modify_castling_rights(piece_placement_data_notation, coordinate, fen_string, piece)
      castling_availability = FEN.parse_castling_availability_field(fen_string).split('')

      colored_castling_availability = castling_availability.select do |char|
        char == (piece.color == :white ? char.upcase : char.downcase)
      end
      piece.moved = true if colored_castling_availability.empty?

      modify_a1_rook_castling_rights(piece_placement_data_notation, coordinate, piece, colored_castling_availability)
      modify_h1_rook_castling_rights(piece_placement_data_notation, coordinate, piece, colored_castling_availability)
      modify_a8_rook_castling_rights(piece_placement_data_notation, coordinate, piece, colored_castling_availability)
      modify_h8_rook_castling_rights(piece_placement_data_notation, coordinate, piece, colored_castling_availability)
    end

    def modify_a1_rook_castling_rights(notation, coordinate, piece, colored_castling_availability)
      return unless notation == 'R' && coordinate == :a1

      piece.moved = true unless colored_castling_availability.include?('Q')
    end

    def modify_h1_rook_castling_rights(notation, coordinate, piece, colored_castling_availability)
      return unless notation == 'R' && coordinate == :h1

      piece.moved = true unless colored_castling_availability.include?('K')
    end

    def modify_a8_rook_castling_rights(notation, coordinate, piece, colored_castling_availability)
      return unless notation == 'r' && coordinate == :a8

      piece.moved = true unless colored_castling_availability.include?('q')
    end

    def modify_h8_rook_castling_rights(notation, coordinate, piece, colored_castling_availability)
      return unless notation == 'r' && coordinate == :h8

      piece.moved = true unless colored_castling_availability.include?('k')
    end

    def add_nil_pieces(file, rank, coordinate, notation)
      notation.to_i.times do
        @board[coordinate][:piece] = nil
        file = (file.ord + 1).chr
        coordinate = (file + rank).to_sym
      end
    end
  end
end
