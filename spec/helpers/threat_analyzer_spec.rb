# frozen_string_literal: true

describe Chess::ThreatAnalyzer do
  let(:color) { double('color') }
  let(:chessboard) { double('chessboard') }
  let(:game) { double('game') }
  subject(:threat_analyzer) { described_class }

  describe '#checkmate' do
    context 'when the legal squares of a player is empty' do
      before do
        allow(Chess::MoveList).to receive(:legal_squares_of_color).with(color, chessboard, game).and_return([])
      end

      it 'returns true as the player has no legal moves' do
        expect(threat_analyzer.checkmate?(color, chessboard, game)).to be true
      end
    end

    context 'when the legal squares of a player is not empty' do
      before do
        allow(Chess::MoveList).to receive(:legal_squares_of_color).with(color, chessboard,
                                                                        game).and_return(%i[a2 a3 a4])
      end

      it 'returns false as the player still has legal moves' do
        expect(threat_analyzer.checkmate?(color, chessboard, game)).to be false
      end
    end
  end
end
