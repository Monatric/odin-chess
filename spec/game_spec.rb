require_relative '../lib/pieces/pawn'
require_relative '../lib/player'
require_relative '../lib/game'
require_relative '../lib/chessboard'

describe Game do
  subject(:game) { described_class.new(chessboard, player_white, player_black, player_white) }
  let(:chessboard) { instance_double(Chessboard) }
  let(:player_white) { instance_double(Player, name: 'Magnus', color: :white) }
  let(:player_black) { instance_double(Player, name: 'Hikaru', color: :black) }
  let(:white_pawn1_not_moved) { instance_double(Pawn, color: :white, player: player_white, moved: false) }

  describe '#piece_can_move_to?' do
    context 'when the piece is a Pawn' do
      context "if the pawn moves two steps and hasn\'t moved" do
        let(:move) { 'e2e4' }
        let(:source) { :e2 }
        let(:dest) { :e4 }

        before do
          allow(game.chessboard).to receive(:assemble).with(player_white, player_black)
          allow(game.chessboard).to receive(:find_piece_by_coordinate).with(source).and_return(white_pawn1_not_moved)
          allow(white_pawn1_not_moved).to receive(:can_move_to?).with(dest, chessboard).and_return(true)
        end

        it 'returns true' do
          result = game.send(:piece_can_move_to?, source, dest)
          expect(result).to be true
        end
      end
    end
  end
end
