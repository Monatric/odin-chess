# frozen_string_literal: true

Dir['../chess/pieces/*.rb'].sort.each { |file| require_relative file }

# to convert piece notations and return related objects
class PieceNotation
  def self.notation_to_piece(notation) # rubocop:disable Metrics/MethodLength
    piece_notation_objects = {
      'r' => Chess::Rook.new(:black),
      'n' => Chess::Knight.new(:black),
      'b' => Chess::Bishop.new(:black),
      'q' => Chess::Queen.new(:black),
      'k' => Chess::King.new(:black),
      'p' => Chess::Pawn.new(:black),
      'R' => Chess::Rook.new(:white),
      'N' => Chess::Knight.new(:white),
      'B' => Chess::Bishop.new(:white),
      'Q' => Chess::Queen.new(:white),
      'K' => Chess::King.new(:white),
      'P' => Chess::Pawn.new(:white)
    }
    piece_notation_objects[notation]
  end
end
