require_relative '../lib/pieces/pawn'
require_relative '../lib/pieces/piece'

require_relative '../lib/player'
require_relative '../lib/game'
require_relative '../lib/chessboard'

describe Pawn do
  subject(:white_pawn) { described_class.new(:white, player_white) }
  subject(:black_pawn) { described_class.new(:black, player_black) }
  let(:chessboard) { instance_double(Chessboard) }
  let(:player_white) { instance_double(Player, name: 'Magnus', color: :white) }
  let(:player_black) { instance_double(Player, name: 'Hikaru', color: :black) }

  before do
    allow(chessboard).to receive(:current_coordinate).with(white_pawn).and_return(:e2)
    # default behavior for #find_piece_by_coordinate to avoid unexpected errors
    allow(chessboard).to receive(:find_piece_by_coordinate).and_return(nil)
  end

  describe '#can_move_to?' do
    context 'when the white pawn is at e2' do
      it 'returns true for e3 (one-square forward move)' do
        expect(white_pawn.can_move_to?(:e3, chessboard)).to be true
      end

      it 'returns true for e4 (two-square forward move)' do
        expect(white_pawn.can_move_to?(:e4, chessboard)).to be true
      end

      it 'returns false for e5 (exceeds pawn move)' do
        expect(white_pawn.can_move_to?(:e5, chessboard)).to be false
      end

      context 'when a black pawn is at d3' do
        before do
          allow(chessboard).to receive(:find_piece_by_coordinate).with(:d3).and_return(black_pawn)
        end

        it 'returns true for d3 (capture move)' do
          expect(white_pawn.can_move_to?(:d3, chessboard)).to be true
        end
      end
    end

    context 'when the white pawn is at e3' do
      subject(:white_pawn_moved) { described_class.new(:white, player_white, true) }
      before do
        allow(chessboard).to receive(:current_coordinate).with(white_pawn_moved).and_return(:e3)
      end

      it 'returns false for e5 (two-square forward move but pawn has moved)' do
        expect(white_pawn.can_move_to?(:e5, chessboard)).to be false
      end
    end
  end
end
