# frozen_string_literal: true

describe Chess::MoveList do
  subject(:move_list) { described_class }

  describe '::generate_list_from' do
    # outgoing query method and it's a simple delegation. No need to test
  end

  describe '::legal_squares_of_color' do
    let(:game) { double('game') }
    let(:chessboard) { double('chessboard') }
    let(:color) { double('color') }

    covered_dests_with_source = {
      a2: %i[a3 a4],
      b2: %i[b3 b4],
      c2: %i[c3 c4],
      b1: %i[a4 c4]
    }

    context 'when the player has legal moves' do
      legal_dests = %i[a4 b3 c3 c4]

      before do
        allow(move_list).to receive(:covered_squares_of_color_with_source).and_return(covered_dests_with_source)
        covered_dests_with_source.map do |source, dests|
          dests.each do |dest|
            response = legal_dests.include?(dest)
            allow(Chess::ThreatAnalyzer).to receive(:move_avoids_check?)
              .with(source, dest, game)
              .and_return(response)
          end
        end
      end

      it 'returns an array of legal coordinates' do
        dests = move_list.legal_squares_of_color(color, chessboard, game)
        expect(dests).to include(*legal_dests)
      end
    end

    context 'when the player has no legal moves' do
      before do
        allow(move_list).to receive(:covered_squares_of_color_with_source).and_return(covered_dests_with_source)
        covered_dests_with_source.map do |source, dests|
          dests.each do |dest|
            allow(Chess::ThreatAnalyzer).to receive(:move_avoids_check?)
              .with(source, dest, game)
              .and_return(false)
          end
        end
      end

      it 'returns an empty array' do
        dests = move_list.legal_squares_of_color(color, chessboard, game)
        expect(dests).to eq []
      end
    end
  end
end
