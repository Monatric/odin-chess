# frozen_string_literal: true

require_relative '../../../lib/chess/pieces/pawn'

describe Chess::Pawn do
  subject(:game) { Game.new }

  describe '#can_move_to?' do
    let(:fen_starting_position) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w KQkq - 0 1' }
    subject(:chessboard) { Chessboard.new(fen_first_field: :fen_starting_position) }

    context 'when the pieces are at the starting position' do
      context 'when the white pawn is at e2' do
        pawn = chessboard.find_coordinate_by_position(:e2)
        two_squares_forward = :e4

        it 'can move two steps forward if the next two squares are empty' do
          expect(pawn.can_move_to?(two_squares_forward, chessboard)).to be true
        end
      end
    end
  end
end
