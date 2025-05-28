# frozen_string_literal: true

require_relative '../../lib/chess'

describe Chess::Game do
  let(:player_one) { instance_double(Player) }
  let(:player_two) { instance_double(Player) }
  let(:chessboard) { instance_double(Chessboard) }
  describe '#save_game' do
    # seems there's no need to test as it is well tested
  end

  describe '#update_fen' do
    let(:fen) { instance_double(FEN) }
    let(:new_fen_string) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }
    subject(:game_update_fen) do
      described_class.new(chessboard: chessboard,
                          player_white: player_one,
                          player_black: player_two,
                          current_turn: player_one,
                          fen: new_fen_string)
    end

    it 'sends generate_fen to fen' do
      expect(fen).to receive(:generate_fen)
      game_update_fen.update_fen
    end
  end
end
