# frozen_string_literal: true

# NOTE: I just realized that the methods here are probably better tested for integration test instead of unit testing.
# Reason being is taht testing the true/false return value, especially for in_check? and move_avoids_check?
# doesn't quite add value at all if it actually does scan for checks. If I would refactor this in the future,
# I'd have to load a game here with an actual FEN. For now, the actual thing works in game.
describe Chess::ThreatAnalyzer do
  let(:color) { double('color') }
  let(:chessboard) { double('chessboard') }
  let(:game) { double('game') }
  subject(:threat_analyzer) { described_class }

  describe '::checkmate' do
    context 'when the legal squares of a player is empty' do
      before do
        allow(Chess::MoveList).to receive(:legal_squares_of_color).with(color, chessboard, game).and_return([])
        allow(threat_analyzer).to receive(:in_check?).with(color, chessboard).and_return(true)
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

  describe '::move_avoids_check?' do
    let(:marshal_dump) { double('marshal dump') }
    let(:board_dup) { double('board dup') }
    let(:source) { double('source') }
    let(:dest) { double('dest') }

    before do
      allow(game).to receive(:current_turn_color).and_return(color)
      allow(game).to receive(:chessboard).and_return(chessboard)
      allow(Marshal).to receive(:dump).with(chessboard).and_return(marshal_dump)
      allow(Marshal).to receive(:load).with(marshal_dump).and_return(board_dup)
      allow(game).to receive(:move_piece)
    end

    context 'when the move avoids check' do
      before do
        allow(threat_analyzer).to receive(:in_check?).and_return(true)
      end

      it 'returns true since it does not leave the king exposed' do
        expect(threat_analyzer.move_avoids_check?(source, dest, game)).to be false
      end
    end

    context 'when the move does not avoid check' do
      before do
        allow(threat_analyzer).to receive(:in_check?).and_return(false)
      end

      it 'returns false since it leaves the king exposed' do
        expect(threat_analyzer.move_avoids_check?(source, dest, game)).to be true
      end
    end
  end
end
