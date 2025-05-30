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
end
