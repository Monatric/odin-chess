require_relative '../lib/pieces/pawn'
require_relative '../lib/player'
require_relative '../lib/game'
require_relative '../lib/chessboard'

describe Game do
  let(:chessboard) { instance_double(Chessboard) }
  let(:player_white) { instance_double(Player, name: 'Magnus', color: :white) }
  let(:player_black) { instance_double(Player, name: 'Hikaru', color: :black) }

  describe '#valid_move?' do
    context 'when the piece is a Pawn' do
      context "if the pawn moves two steps and hasn\'t moved" do
        subject(:game) { described_class.new(chessboard, player_white, player_black, player_white) }
        let(:move) { 'e2e4' }
        let(:source) { :e2 }
        let(:dest) { :e4 }
        let(:white_pawn1_not_moved) { instance_double(Pawn, color: :white, player: player_white, moved: false) }

        before do
          allow(game.chessboard).to receive(:find_piece_by_coordinate).with(source)
          allow(game.chessboard).to receive(:add_piece).with(source, white_pawn1_not_moved)
          allow(white_pawn1_not_moved).to receive(:can_move_to?).with(dest, chessboard).and_return(true)
          allow(game).to receive(:valid_coordinate?).with(source, dest).and_return(true)
          allow(game).to receive(:piece_belongs_to_current_player?).with(source).and_return(true)
          # allow(game).to receive(:piece_can_move_to?).with(source, dest).and_return(true)
        end

        it 'returns true' do
          result = game.valid_move?(move)
          expect(result).to be true
        end
      end
    end
  end
end
