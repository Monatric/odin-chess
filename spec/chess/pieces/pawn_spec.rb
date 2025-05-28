# frozen_string_literal: true

RSpec.shared_examples 'pawn forward moves' do |current_coordinate, moves_hash|
  let(:fen) { fen_string }
  let(:chessboard) { Chess::Chessboard.new(fen_string: fen) }
  let(:pawn) { chessboard.find_piece_by_coordinate(current_coordinate) }

  moves_hash.each do |coordinate, allowed|
    it "#{allowed ? 'allows' : 'disallows'} movement to #{coordinate}" do
      expect(pawn.can_move_to?(coordinate, chessboard)).to eq(allowed)
    end
  end
end

describe 'Pawn functionality' do
  describe '#can_move_to?' do
    context 'when the pawn is white' do
      context 'when the pawn is at starting position (e2)' do
        let(:fen_string) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w KQkq - 0 1' }

        include_examples 'pawn forward moves', :e2, { e3: true, e4: true, e5: false }
      end

      context 'when the pawn faces a black piece in front (at e4)' do
        let(:fen_two_opposing_pawns) { 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2' }
        let(:chessboard) { Chess::Chessboard.new(fen_string: fen_two_opposing_pawns) }
        let(:pawn) { chessboard.find_piece_by_coordinate(:e4) }

        %i[e5 e3 d4 f4 d5 f5 d3 f3].each do |coordinate|
          it "disallows movement to #{coordinate}" do
            expect(pawn.can_move_to?(coordinate, chessboard)).to be false
          end
        end
      end

      context 'when the pawn tries to capture (at e4, facing a black piece diagonally)' do
        let(:fen_capturable_black_pieces) { 'rn1qkbnr/ppp1pppp/8/3p1b2/4P3/P7/1PPP1PPP/RNBQKBNR w KQkq - 1 3' }
        let(:chessboard) { Chess::Chessboard.new(fen_string: fen_capturable_black_pieces) }
        let(:pawn) { chessboard.find_piece_by_coordinate(:e4) }

        captures = {
          d5: true,
          f5: true
        }

        captures.each do |coordinate, allowed|
          it "can capture diagonally (#{coordinate})" do
            expect(pawn.can_move_to?(coordinate, chessboard)).to be allowed
          end
        end
      end

      context 'when the pawn tries to en passant to the left (at e5 with an en passantable black pawn on d5)' do
        let(:fen_en_passantable_black_pawn) { 'rnbqkbnr/1pp1pppp/p7/3pP3/8/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 3' }
        let(:chessboard) { Chess::Chessboard.new(fen_string: fen_en_passantable_black_pawn) }
        let(:pawn) { chessboard.find_piece_by_coordinate(:e5) }

        it 'can capture black pawn on d5' do
          en_passantable_square = :d6
          result = pawn.can_move_to?(en_passantable_square, chessboard)
          expect(result).to be true
        end
      end

      context 'when the pawn tries to en passant to the right (at a5 with an en passantable black pawn on b5)' do
        let(:fen_en_passantable_black_pawn) { 'rnbqkbnr/p1ppppp1/7p/Pp6/8/8/1PPPPPPP/RNBQKBNR w KQkq b6 0 3' }
        let(:chessboard) { Chess::Chessboard.new(fen_string: fen_en_passantable_black_pawn) }
        let(:pawn) { chessboard.find_piece_by_coordinate(:a5) }

        it 'can capture black pawn on b5' do
          en_passantable_square = :b6
          result = pawn.can_move_to?(en_passantable_square, chessboard)
          expect(result).to be true
        end
      end

      context 'when the pawn checks the black king' do
        let(:fen_checked_black_king) { '8/3k4/4P3/8/8/8/8/4K3 b - - 0 1' }
        let(:chessboard) { Chess::Chessboard.new(fen_string: fen_checked_black_king) }
        let(:pawn) { chessboard.find_piece_by_coordinate(:e6) }

        it 'checks the black king' do
          result = Chess::ThreatAnalyzer.in_check?(:black, chessboard)
          expect(result).to be true
        end
      end
    end

    context 'when the pawn is black' do
      context 'when the pawn is at starting position (e7)' do
        let(:fen_string) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b KQkq - 0 1' }

        include_examples 'pawn forward moves', :e7, { e6: true, e5: true, e4: false }
      end

      context 'when the pawn faces a white piece in front (at e5)' do
        let(:fen_two_opposing_pawns) { 'rnbqkbnr/pppp1ppp/8/4p3/4P3/P7/1PPP1PPP/RNBQKBNR b KQkq - 0 2' }
        let(:chessboard) { Chess::Chessboard.new(fen_string: fen_two_opposing_pawns) }
        let(:pawn) { chessboard.find_piece_by_coordinate(:e5) }

        %i[e4 e6 d5 f5 d6 f6 d4 f4].each do |coordinate|
          it "disallows movement to #{coordinate}" do
            expect(pawn.can_move_to?(coordinate, chessboard)).to be false
          end
        end
      end

      context 'when the pawn tries to capture (at e5, facing a white piece diagonally)' do
        let(:fen_capturable_white_pieces) { 'rnbqkbnr/ppp1pppp/8/3p4/2P1P3/8/PP1P1PPP/RNBQKBNR b KQkq - 0 2' }
        let(:chessboard) { Chess::Chessboard.new(fen_string: fen_capturable_white_pieces) }
        let(:pawn) { chessboard.find_piece_by_coordinate(:d5) }

        captures = {
          c4: true,
          e4: true
        }

        captures.each do |coordinate, allowed|
          it "can capture diagonally (#{coordinate})" do
            expect(pawn.can_move_to?(coordinate, chessboard)).to be allowed
          end
        end
      end

      context 'when the pawn tries to en passant to the right (at e4 with an en passantable white pawn on d4)' do
        let(:fen_en_passantable_white_pawn) { 'rnbqkbnr/pppp1ppp/8/8/P2Pp3/8/1PP1PPPP/RNBQKBNR b KQkq d3 0 3' }
        let(:chessboard) { Chess::Chessboard.new(fen_string: fen_en_passantable_white_pawn) }
        let(:pawn) { chessboard.find_piece_by_coordinate(:e4) }

        it 'can capture white pawn en passant to d3' do
          en_passant_target = :d3
          result = pawn.can_move_to?(en_passant_target, chessboard)
          expect(result).to be true
        end
      end

      context 'when the pawn tries to en passant to the left (at a4 with an en passantable white pawn on b4)' do
        let(:fen_en_passantable_white_pawn_side) { 'rnbqkbnr/1ppppppp/8/8/pP5P/8/P1PPPPP1/RNBQKBNR b KQkq b3 0 3' }
        let(:chessboard) { Chess::Chessboard.new(fen_string: fen_en_passantable_white_pawn_side) }
        let(:pawn) { chessboard.find_piece_by_coordinate(:a4) }

        it 'can capture white pawn en passant to b3' do
          en_passant_target = :b3
          result = pawn.can_move_to?(en_passant_target, chessboard)
          expect(result).to be true
        end
      end

      context 'when the pawn checks the white king' do
        let(:fen_checked_white_king) { '8/8/8/8/4p3/3K4/8/8 b - - 0 1' }
        let(:chessboard) { Chess::Chessboard.new(fen_string: fen_checked_white_king) }
        let(:pawn) { chessboard.find_piece_by_coordinate(:e4) }

        it 'checks the white king' do
          result = Chess::ThreatAnalyzer.in_check?(:white, chessboard)
          expect(result).to be true
        end
      end
    end
  end

  describe '#promote' do
    context 'when the white pawn promotes' do
      let(:fen_pawn_promoting) { '5k2/3P4/8/8/8/8/8/3K4 w - - 0 1' }
      let(:chessboard) { Chess::Chessboard.new(fen_string: fen_pawn_promoting) }
      let(:pawn) { chessboard.find_piece_by_coordinate(:d7) }
      let(:promotion_piece) { instance_double(Chess::Queen, color: :white) }

      before do
        allow(Chess::PawnPromotion)
          .to receive(:select_promotion_piece)
          .with(pawn.color, dup: false)
          .and_return(promotion_piece)

        allow(chessboard).to receive(:remove_piece)
        allow(chessboard).to receive(:add_piece)
      end

      it 'asks PawnPromotion for the correct piece and then replaces the pawn' do
        pawn.promote(:d8, chessboard, dup: false)

        expect(Chess::PawnPromotion)
          .to have_received(:select_promotion_piece)
          .with(pawn.color, dup: false)

        expect(chessboard).to have_received(:remove_piece).with(:d7)
        expect(chessboard).to have_received(:add_piece).with(:d8, promotion_piece)
      end
    end

    context 'when the black pawn promotes' do
      let(:fen_pawn_promoting) { '5k2/8/8/8/8/8/3p4/6K1 b - - 1 1' }
      let(:chessboard) { Chess::Chessboard.new(fen_string: fen_pawn_promoting) }
      let(:pawn) { chessboard.find_piece_by_coordinate(:d2) }
      let(:promotion_piece) { instance_double(Chess::Queen, color: :black) }

      before do
        allow(Chess::PawnPromotion)
          .to receive(:select_promotion_piece)
          .with(pawn.color, dup: false)
          .and_return(promotion_piece)

        allow(chessboard).to receive(:remove_piece)
        allow(chessboard).to receive(:add_piece)
      end

      it 'asks PawnPromotion for the correct piece and then replaces the pawn' do
        pawn.promote(:d1, chessboard, dup: false)

        expect(Chess::PawnPromotion)
          .to have_received(:select_promotion_piece)
          .with(pawn.color, dup: false)

        expect(chessboard).to have_received(:remove_piece).with(:d2)
        expect(chessboard).to have_received(:add_piece).with(:d1, promotion_piece)
      end
    end
  end
end
