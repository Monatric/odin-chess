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
    let(:fen_starting_position) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w KQkq - 0 1' }
    let(:chessboard) { Chess::Chessboard.new(fen_first_field: fen_starting_position) }
    let(:game) { Chess::Game.new(chessboard) }

    context 'when the pieces are at the starting position' do
      context 'when the white pawn is at e2' do
        it 'can move two steps forward if the next two squares are empty' do
          pawn = chessboard.find_piece_by_coordinate(:e2)
          two_squares_forward = :e4

          expect(pawn.can_move_to?(two_squares_forward, chessboard)).to be true
        end
      end
    end
  end
end
