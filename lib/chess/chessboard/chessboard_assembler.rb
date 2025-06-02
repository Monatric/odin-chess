# frozen_string_literal: true

module Chess
  # class for the chess board and its states
  class ChessboardAssembler
    include Convertable
    def initialize(board_properties:, chessboard: Chessboard.new)
      @chessboard = chessboard
      @board_properties = board_properties
    end

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
          @board_properties[coordinate][:piece] = piece

          king_and_rook_notations = (piece.color == :white ? %w[K R] : %w[k r])
          if king_and_rook_notations.include?(notation)
            modify_castling_rights(notation, coordinate, fen_string,
                                   piece)
          end
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
      piece = @chessboard.find_piece_by_coordinate(en_passantable_pawn_coordinate)

      en_passant_movement = PawnEnPassant.new(pawn: piece,
                                              dest: en_passantable_pawn_coordinate,
                                              chessboard: @chessboard)

      source_offset = (piece.color == :white ? -2 : 2)
      source = coordinate_string_to_symbol(en_passantable_pawn_coordinate, rank_offset: source_offset)
      en_passant_movement.signal_en_passant(source)
    end

    private

    def modify_castling_rights(piece_placement_data_notation, coordinate, fen_string, piece)
      castling_availability = FEN.parse_castling_availability_field(fen_string).split('')

      colored_castling_availability = castling_availability.select do |char|
        char == (piece.color == :white ? char.upcase : char.downcase)
      end
      piece.moved = true if colored_castling_availability.include?('-')

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
        @board_properties[coordinate][:piece] = nil
        file = (file.ord + 1).chr
        coordinate = (file + rank).to_sym
      end
    end
  end
end
