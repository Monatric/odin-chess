# frozen_string_literal: true

require_relative '../../../lib/chess/pieces/pawn'
require_relative '../../../lib/chess/pieces/rook'
require_relative '../../../lib/chess/pieces/knight'
require_relative '../../../lib/chess/pieces/bishop'
require_relative '../../../lib/chess/pieces/king'
require_relative '../../../lib/chess/pieces/queen'

# Dir['../../../lib/chess/pieces/*.rb'].sort.each { |file| require_relative file }
require_relative '../../../lib/chess/chessboard/chessboard_assembler'
require_relative '../../../lib/chess/chessboard'
require_relative '../../../lib/helpers/threat_analyzer'
require_relative '../../../lib/helpers/move_list'
require_relative '../../../lib/chess'

describe 'Pawn functionality' do
  describe '#can_move_to?' do
    context 'when the pawn is white at starting position (e2)' do
      let(:fen_starting_position) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w KQkq - 0 1' }
      let(:chessboard) { Chess::Chessboard.new(fen_string: fen_starting_position) }
      let(:pawn) { chessboard.find_piece_by_coordinate(:e2) }

      # expected outcome
      moves = {
        e3: true, # one square
        e4: true, # two squares
        e5: false # too far
      }

      moves.each do |coordinate, allowed|
        it "#{allowed ? 'allows' : 'disallows'} movement to #{coordinate}" do
          expect(pawn.can_move_to?(coordinate, chessboard)).to be allowed
        end
      end
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

      it 'can capture up left' do
        one_square_up_left = :d5
        result = pawn.can_move_to?(one_square_up_left, chessboard)
        expect(result).to be true
      end

      it 'can capture up right' do
        one_square_up_right = :f5
        result = pawn.can_move_to?(one_square_up_right, chessboard)
        expect(result).to be true
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

    context 'when the pawn is black' do
      context 'when the pawn has not moved (at e7)' do
        let(:fen_starting_position) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b KQkq - 0 1' }
        let(:chessboard) { Chess::Chessboard.new(fen_string: fen_starting_position) }
        let(:pawn) { chessboard.find_piece_by_coordinate(:e7) }

        it 'can move one step forward (down) if the next square is empty' do
          one_square_forward = :e6
          result = pawn.can_move_to?(one_square_forward, chessboard)
          expect(result).to be true
        end

        it 'can move two steps forward (down) if the next two squares are empty' do
          two_squares_forward = :e5
          result = pawn.can_move_to?(two_squares_forward, chessboard)
          expect(result).to be true
        end

        it 'cannot move more than two steps forward' do
          three_squares_forward = :e4
          result = pawn.can_move_to?(three_squares_forward, chessboard)
          expect(result).to be false
        end
      end

      context 'when the pawn faces a white piece in front (at e5)' do
        let(:fen_two_opposing_pawns) { 'rnbqkbnr/pppp1ppp/8/4p3/4P3/P7/1PPP1PPP/RNBQKBNR b KQkq - 0 2' }
        let(:chessboard) { Chess::Chessboard.new(fen_string: fen_two_opposing_pawns) }
        let(:pawn) { chessboard.find_piece_by_coordinate(:e5) }

        it 'cannot move forward (down) into occupied square' do
          one_square_forward = :e4
          result = pawn.can_move_to?(one_square_forward, chessboard)
          expect(result).to be false
        end

        it 'cannot move backward (up)' do
          one_square_backward = :e6
          result = pawn.can_move_to?(one_square_backward, chessboard)
          expect(result).to be false
        end

        it 'cannot move left' do
          one_square_left = :d5
          result = pawn.can_move_to?(one_square_left, chessboard)
          expect(result).to be false
        end

        it 'cannot move right' do
          one_square_right = :f5
          result = pawn.can_move_to?(one_square_right, chessboard)
          expect(result).to be false
        end

        it 'cannot move up left' do
          diag_up_left = :d6
          result = pawn.can_move_to?(diag_up_left, chessboard)
          expect(result).to be false
        end

        it 'cannot move up right' do
          diag_up_right = :f6
          result = pawn.can_move_to?(diag_up_right, chessboard)
          expect(result).to be false
        end

        it 'cannot move down left' do
          diag_down_left = :d4
          result = pawn.can_move_to?(diag_down_left, chessboard)
          expect(result).to be false
        end

        it 'cannot move down right' do
          diag_down_right = :f4
          result = pawn.can_move_to?(diag_down_right, chessboard)
          expect(result).to be false
        end
      end

      context 'when the pawn tries to capture (at e5, facing a white piece diagonally)' do
        let(:fen_capturable_white_pieces) { 'rnbqkbnr/ppp1pppp/8/3p4/2P1P3/8/PP1P1PPP/RNBQKBNR b KQkq - 0 2' }
        let(:chessboard) { Chess::Chessboard.new(fen_string: fen_capturable_white_pieces) }
        let(:pawn) { chessboard.find_piece_by_coordinate(:d5) }

        it 'can capture down left' do
          one_square_down_left = :c4
          result = pawn.can_move_to?(one_square_down_left, chessboard)
          expect(result).to be true
        end

        it 'can capture down right' do
          one_square_down_right = :e4
          result = pawn.can_move_to?(one_square_down_right, chessboard)
          expect(result).to be true
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
    context 'when the pawn promotes' do
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
  end
end
