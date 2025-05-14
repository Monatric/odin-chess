# frozen_string_literal: true

require_relative '../../../lib/chess/pieces/pawn'
require_relative '../../../lib/chess/pieces/rook'
require_relative '../../../lib/chess/pieces/knight'
require_relative '../../../lib/chess/pieces/bishop'
require_relative '../../../lib/chess/pieces/king'
require_relative '../../../lib/chess/pieces/queen'

# Dir['../../../lib/chess/pieces/*.rb'].sort.each { |file| require_relative file }
require_relative '../../../lib/chess/chessboard/chessboard_assembler'
require_relative '../../../lib/chess/chessboard'
require_relative '../../../lib/chess'

describe 'Pawn functionality' do
  describe '#can_move_to?' do
    context 'when the white pawn is at e2' do
      let(:fen_starting_position) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w KQkq - 0 1' }
      let(:chessboard) { Chess::Chessboard.new(fen_string: fen_starting_position) }
      let(:pawn) { chessboard.find_piece_by_coordinate(:e2) }

      it 'can move one step forward if the next square are empty' do
        one_square_forward = :e3
        expect(pawn.can_move_to?(one_square_forward, chessboard)).to be true
      end

      it 'can move two steps forward if the next two squares are empty' do
        two_squares_forward = :e4
        expect(pawn.can_move_to?(two_squares_forward, chessboard)).to be true
      end

      it 'cannot move more than two steps forward' do
        three_squares_forward = :e5
        expect(pawn.can_move_to?(three_squares_forward, chessboard)).to be false
      end
    end

    context 'when the white pawn is at e4, facing a black pawn at e5' do
      let(:fen_two_opposing_pawns) { 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2' }
      let(:chessboard) { Chess::Chessboard.new(fen_string: fen_two_opposing_pawns) }
      let(:pawn) { chessboard.find_piece_by_coordinate(:e4) }

      it 'cannot move forward' do
        one_square_forward = :e5
        expect(pawn.can_move_to?(one_square_forward, chessboard)).to be false
      end

      it 'cannot move backward' do
        one_square_backward = :e3
        expect(pawn.can_move_to?(one_square_backward, chessboard)).to be false
      end

      it 'cannot move left' do
        one_square_left = :d4
        expect(pawn.can_move_to?(one_square_left, chessboard)).to be false
      end

      it 'cannot move right' do
        one_square_right = :f4
        expect(pawn.can_move_to?(one_square_right, chessboard)).to be false
      end

      it 'cannot move up left' do
        one_square_up_left = :d5
        expect(pawn.can_move_to?(one_square_up_left, chessboard)).to be false
      end

      it 'cannot move up right' do
        one_square_up_right = :f5
        expect(pawn.can_move_to?(one_square_up_right, chessboard)).to be false
      end

      it 'cannot move down left' do
        one_square_down_left = :d3
        expect(pawn.can_move_to?(one_square_down_left, chessboard)).to be false
      end

      it 'cannot move down right' do
        one_square_down_right = :f3
        expect(pawn.can_move_to?(one_square_down_right, chessboard)).to be false
      end
    end
  end
end
