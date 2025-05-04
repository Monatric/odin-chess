# frozen_string_literal: true

require_relative '../../../lib/chess/pieces/pawn'
require_relative '../../../lib/chess/pieces/rook'
require_relative '../../../lib/chess/pieces/knight'
require_relative '../../../lib/chess/pieces/bishop'
require_relative '../../../lib/chess/pieces/king'
require_relative '../../../lib/chess/pieces/queen'

# Dir['../../../lib/chess/pieces/*.rb'].sort.each { |file| require_relative file }
require_relative '../../../lib/chess/chessboard'

describe 'Pawn functionality' do
  describe '#can_move_to?' do
    context 'when the white pawn is at e2' do
      let(:fen_starting_position) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/' }
      let(:chessboard) { Chess::Chessboard.new(fen_first_field: fen_starting_position) }
      let(:game) { Chess::Game.new(chessboard) }

      it 'can move one step forward if the next square are empty' do
        pawn = chessboard.find_piece_by_coordinate(:e2)
        one_square_forward = :e3

        expect(pawn.can_move_to?(one_square_forward, chessboard)).to be true
      end

      it 'can move two steps forward if the next two squares are empty' do
        pawn = chessboard.find_piece_by_coordinate(:e2)
        two_squares_forward = :e4

        expect(pawn.can_move_to?(two_squares_forward, chessboard)).to be true
      end

      it 'cannot move more than two steps forward' do
        pawn = chessboard.find_piece_by_coordinate(:e2)
        three_squares_forward = :e5

        expect(pawn.can_move_to?(three_squares_forward, chessboard)).to be false
      end
    end
  end
end
