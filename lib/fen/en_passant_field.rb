# frozen_string_literal: true

module Chess
  # class for generating the fourth field of FEN, responsible for showing which square is eligible for en passant
  class EnPassantField
    def self.generate(chessboard)
      no_en_passant_square = '-'
      result = nil
      # check all files of the given rank to find out if a pawn is en passantable
      ('a'..'h').each do |file|
        5.downto(4).each do |rank|
          coordinate = "#{file}#{rank}".to_sym
          piece = chessboard.find_piece_by_coordinate(coordinate)
          en_passantable_square = piece&.en_passantable_square(chessboard) if piece.respond_to?(:en_passant_signal)
          result = en_passantable_square unless en_passantable_square.nil?
        end
      end
      result = (result.nil? ? no_en_passant_square : result) # default hyphen, no en passant square
    end
  end
end
