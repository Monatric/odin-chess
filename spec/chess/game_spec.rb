# frozen_string_literal: true

describe Chess::Game do
  let(:player_one) { instance_double(Player) }
  let(:player_two) { instance_double(Player) }
  let(:chessboard) { instance_double(Chess::Chessboard) }
  let(:fen) { instance_double(Chess::FEN) }

  describe '#save_game' do
    # seems there's no need to test as it is well tested
  end

  describe '#update_fen' do
    context 'when updating the string of FEN' do
      let(:new_fen_string) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      subject(:game_update_fen) do
        described_class.new(chessboard: chessboard,
                            player_white: player_one,
                            player_black: player_two,
                            current_turn: player_one,
                            fen: new_fen_string)
      end
      before do
        allow(Chess::FEN).to receive(:new).and_return(fen)
      end

      it 'sends generate_fen to fen' do
        expect(fen).to receive(:generate_fen).and_return(new_fen_string)
        game_update_fen.update_fen
      end
    end
  end
end
