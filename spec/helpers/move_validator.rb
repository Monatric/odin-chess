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

  describe '#move_is_promotion?' do
    let(:source) { double }
    let(:dest) { double }
    let(:piece) { double }
    subject(:move_validator) { described_class.new(source: source, dest: dest, game: game) }

    before do
      allow(game).to receive(:chessboard).and_return(chessboard)
    end

    context 'when the move is a white pawn for promotion' do
      promotion_squares = %i[a8 b8 c8 d8 e8 f8 g8 h8]

      before do
        allow(piece).to receive(:is_a?).with(Chess::Pawn).and_return(true)

        promotion_squares.each do |square|
          allow(Chess::PawnPromotion)
            .to receive(:promotion_square?)
            .with(piece, square)
            .and_return(true)
        end
      end

      promotion_squares.each do |square|
        it "returns true for promotion square #{square}" do
          expect(move_validator.move_is_promotion?(piece, square)).to be true
        end
      end
    end

    context 'when the move is a black pawn for promotion' do
      promotion_squares = %i[a1 b1 c1 d1 e1 f1 g1 h1]

      before do
        allow(piece).to receive(:is_a?).with(Chess::Pawn).and_return(true)

        promotion_squares.each do |square|
          allow(Chess::PawnPromotion)
            .to receive(:promotion_square?)
            .with(piece, square)
            .and_return(true)
        end
      end

      promotion_squares.each do |square|
        it "returns true for promotion square #{square}" do
          expect(move_validator.move_is_promotion?(piece, square)).to be true
        end
      end
    end

    context 'when the move is not for promotion' do
      let(:non_promotion_square) { :e5 }
      before do
        allow(piece).to receive(:is_a?).with(Chess::Pawn).and_return(true)

        allow(Chess::PawnPromotion)
          .to receive(:promotion_square?)
          .with(piece, non_promotion_square)
          .and_return(false)
      end

      it 'returns false for non-promotion square' do
        expect(move_validator.move_is_promotion?(piece, non_promotion_square)).to be false
      end
    end

    context 'when the move is a promotion square but not a pawn' do
      before do
        allow(piece).to receive(:is_a?).with(Chess::Pawn).and_return(false)

        allow(Chess::PawnPromotion)
          .to receive(:promotion_square?)
          .with(piece, dest)
          .and_return(true)
      end

      it 'returns false' do
        expect(move_validator.move_is_promotion?(piece, dest)).to be false
      end
    end
  end

  describe '#valid_format?' do
    context 'when the source and destination have a total length of 4' do
      subject(:move_validator) { described_class.new(source: :e2, dest: :e4, game: game) }

      before do
        allow(game).to receive(:chessboard).and_return(chessboard)
      end

      it 'returns true as it is valid' do
        expect(move_validator.valid_format?).to be true
      end
    end

    context 'when the source and destination does not have a total length of 4' do
      subject(:move_validator) { described_class.new(source: :d51, dest: :a6, game: game) }

      before do
        allow(game).to receive(:chessboard).and_return(chessboard)
      end

      it 'returns false as it is invalid' do
        expect(move_validator.valid_format?).to be false
      end
    end
  end

  describe '#valid_positions?' do
    # an outgoing query method. No need to test
  end

  describe '#castling_attempt?' do
    # duplicated method. Refactor later
  end

  describe '#valid_castling?' do
    let(:king) { double('king') }
    let(:rook) { double('rook') }
    let(:source) { double }
    let(:dest) { double }
    subject(:move_validator) { described_class.new(source: source, dest: dest, game: game) }

    context 'when the king and rook are castleable and avoids check' do
      before do
        allow(game).to receive(:chessboard).and_return(chessboard)
        allow(Chess::ThreatAnalyzer).to receive(:move_avoids_check?).and_return(true)
        allow(game.chessboard).to receive(:find_piece_by_coordinate).and_return(king)
        allow(game.chessboard).to receive(:find_piece_by_coordinate).and_return(rook)
        allow(king).to receive(:castleable?).and_return(true)
        allow(rook).to receive(:castleable?).and_return(true)
      end

      it 'returns true as it is a valid castling' do
        expect(move_validator.valid_castling?).to be true
      end
    end

    context 'when only one of the piece is castleable' do
      let(:source)     { :e1 } # must match king_coord
      let(:dest)       { :c1 } # will map to rook_coord :a1 in hash
      let(:king_coord) { :e1 }
      let(:rook_coord) { :a1 }

      before do
        allow(game).to receive(:chessboard).and_return(chessboard)
        allow(Chess::ThreatAnalyzer).to receive(:move_avoids_check?).and_return(true)
        allow(chessboard).to receive(:find_piece_by_coordinate).with(king_coord).and_return(king)
        allow(chessboard).to receive(:find_piece_by_coordinate).with(rook_coord).and_return(rook)
        allow(king).to receive(:castleable?).and_return(false)
        allow(rook).to receive(:castleable?).and_return(true)
      end

      it 'returns false as it is an invalid castling' do
        expect(move_validator.valid_castling?).to be false
      end
    end
  end

  describe '#piece_belongs_to_current_player?' do
    let(:source) { double('source') }
    let(:dest) { double('dest') }
    let(:piece) { double('piece') }
    subject(:move_validator) { described_class.new(source: source, dest: dest, game: game) }

    before do
      allow(game).to receive(:chessboard).and_return(chessboard)
      allow(chessboard).to receive(:find_piece_by_coordinate).with(source).and_return(piece)
    end

    context 'when the piece belongs to the current player' do
      before do
        allow(piece).to receive(:color).and_return(:white)
        allow(game).to receive(:current_turn_color).and_return(:white)
      end

      it 'returns true' do
        expect(move_validator.piece_belongs_to_current_player?).to be true
      end
    end

    context 'when the piece color does not match to the current turn color' do
      before do
        allow(piece).to receive(:color).and_return(:black)
        allow(game).to receive(:current_turn_color).and_return(:white)
      end

      it 'returns false' do
        expect(move_validator.piece_belongs_to_current_player?).to be false
      end
    end
  end

  describe '#piece_can_move_to?' do
    let(:source) { double('source') }
    let(:dest) { double('dest') }
    let(:piece) { double('piece') }
    subject(:move_validator) { described_class.new(source: source, dest: dest, game: game) }

    before do
      allow(game).to receive(:chessboard).and_return(chessboard)
      allow(chessboard).to receive(:find_piece_by_coordinate).with(source).and_return(piece)
    end

    context 'when the piece can move to a dest' do
      before do
        allow(piece).to receive(:can_move_to?).with(dest, chessboard).and_return(true)
      end

      it 'returns true' do
        expect(move_validator.piece_can_move_to?).to be true
      end
    end

    context 'when the piece can move to a dest' do
      before do
        allow(piece).to receive(:can_move_to?).with(dest, chessboard).and_return(false)
      end

      it 'returns true' do
        expect(move_validator.piece_can_move_to?).to be true
      end
    end
  end
end
