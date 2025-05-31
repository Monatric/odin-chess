# frozen_string_literal: true

describe Chess::ThreatAnalyzer do
  let(:color) { double('color') }
  let(:chessboard) { double('chessboard') }
  let(:game) { double('game') }
  subject(:threat_analyzer) { described_class }

  describe '::checkmate' do
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

  describe '::in_check?' do
    let(:color) { :white }
    let(:covered_squares) { %i[b4 c6 g8 e1 a2] }

    context "when player's king is in check" do
      let(:king_coordinate) { :e1 }

      before do
        allow(chessboard).to receive(:king_coordinate).with(color).and_return(king_coordinate)
        allow(Chess::MoveList).to receive(:covered_squares_of_color).with(:black,
                                                                          chessboard).and_return(covered_squares)
      end

      it "returns true as the king's coordinate is covered by the other player" do
        expect(threat_analyzer.in_check?(color, chessboard)).to be true
      end
    end

    context "when player's king is not in check" do
      let(:king_coordinate) { :g1 }
      before do
        allow(chessboard).to receive(:king_coordinate).with(color).and_return(king_coordinate)
        allow(Chess::MoveList).to receive(:covered_squares_of_color).with(:black,
                                                                          chessboard).and_return(covered_squares)
      end

      it "returns false as the king's coordinate is not covered by the other player" do
        expect(threat_analyzer.in_check?(color, chessboard)).to be false
      end
    end
  end
end
