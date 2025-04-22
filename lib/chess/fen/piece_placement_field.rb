# frozen_string_literal: true

module Chess
  # class for generating the first field of FEN, responsible for showing the position of the pieces and the board
  class PiecePlacementField
    def self.generate(chessboard)
      space = 0
      piece_placement_field_array = []
      add_piece_placement_field(space, piece_placement_field_array, chessboard)
      piece_placement_field_array.join('')
    end

    def self.add_piece_placement_field(space, piece_placement_field_array, chessboard)
      first_file = FILE_ORDINALS[:first]
      last_file = FILE_ORDINALS[:eighth]
      8.downto(1) do |rank|
        (first_file..last_file).each do |file|
          coordinate = (file + rank.to_s).to_sym
          piece = chessboard.find_piece_by_coordinate(coordinate)

          space = add_space_between_piece(piece, space, piece_placement_field_array)
        end
        piece_placement_field_array << space.to_s unless space.zero?
        piece_placement_field_array << '/'
        space = 0
      end
    end

    def self.add_space_between_piece(piece, space, piece_placement_field_array)
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
