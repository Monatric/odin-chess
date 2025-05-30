# frozen_string_literal: true

describe Chess::MoveValidator do
  let(:game) { double('game') }
  let(:chessboard) { double('chessboard') }
  # subject(:move_validator) { described_class.new()}
  describe '#valid_move?' do
    context 'when the move attempt is castling but it is an illegal move' do
      let(:castling_source) { :e1 }
      let(:castling_dest) { :g1 }
      subject(:move_validator) { described_class.new(source: castling_source, dest: castling_dest, game: game) }

      before do
        allow(game).to receive(:chessboard).and_return(chessboard)
        allow(move_validator).to receive(:castling_attempt?).and_return(true)
        allow(move_validator).to receive(:valid_castling?).and_return(false)
      end

      it 'returns false' do
        result = move_validator.valid_move?
        expect(result).to be false
      end
    end

    # Feels like it adds no value to test for other methods that is being called
    # in #valid_move? since it is all about returning true or false
  end

  describe '#move_is_castling?' do
    let(:source) { double }
    let(:dest) { double }
    subject(:move_validator) { described_class.new(source: source, dest: dest, game: game) }

    before do
      allow(game).to receive(:chessboard).and_return(chessboard)
    end

    context 'when the move is a valid castling notation' do
      castling_notations = {
        e1: %i[g1 c1],
        e8: %i[g8 c8]
      }

      castling_notations.each do |source, dests|
        dests.each do |dest|
          it "returns true for #{source}#{dest}" do
            expect(move_validator.move_is_castling?(source, dest)).to be true
          end
        end
      end
    end

    context 'when the move is an invalid castling notation' do
      it 'returns false for invalid source and dest' do
        expect(move_validator.move_is_castling?(:b1, :e7)).to be false
      end

      it 'returns false for invalid source and valid dest' do
        expect(move_validator.move_is_castling?(:b1, :e1)).to be false
      end

      it 'returns false for valid source and invalid dest' do
        expect(move_validator.move_is_castling?(:e1, :a8)).to be false
      end
    end
  end
end
