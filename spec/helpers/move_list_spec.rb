# frozen_string_literal: true

describe Chess::MoveList do
  subject(:move_list) { described_class }
  let(:chessboard) { double('chessboard') }
  let(:game) { double('game') }
  let(:color) { double('color') }

  describe '::generate_list_from' do
    # outgoing query method and it's a simple delegation. No need to test
  end

  describe '::legal_squares_of_color' do
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

  describe '::covered_squares_of_color' do
    let(:pawn) { double('pawn') }
    let(:bishop) { double('bishop') }
    let(:knight) { double('knight') }

    context 'when the pieces have covered squares' do
      let(:squares_with_pieces) do
        {
          e4: { piece: pawn, moves: [:e5] },
          b1: { piece: knight, moves: %i[a3 c3] },
          c1: { piece: bishop, moves: %i[d2 e3 f4 g5 h6] }
        }
      end

      before do
        allow(chessboard).to receive(:find_squares_with_pieces_by_color).with(color).and_return(squares_with_pieces)
        squares_with_pieces.each_value do |info|
          allow(info[:piece]).to receive(:generate_possible_moves).with(chessboard).and_return(info[:moves])
        end
      end

      it 'returns an array of all covered squares of a piece' do
        covered_squares = %i[e5 a3 c3 d2 e3 f4 g5 h6]
        result = move_list.covered_squares_of_color(color, chessboard)
        expect(result).to match_array(covered_squares)
      end
    end
  end
end
