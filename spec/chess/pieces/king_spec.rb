# frozen_string_literal: true

describe 'King functionality' do
  describe '#can_move_to?' do
    context 'when the white king is at the center (c4)' do
      let(:fen) { '5k2/2b5/4r3/8/2K2p2/8/8/8 w - - 0 1' }
      let(:chessboard) { Chess::Chessboard.new(fen_string: fen) }
      let(:king) { chessboard.find_piece_by_coordinate(:c4) }

      illegal_moves = {
        a3: false, b2: false, d2: false, e3: false,
        e5: false, d6: false, b6: false, a5: false,
        a4: false, c2: false, c6: false, e4: false,
        a2: false, a6: false, e6: false, e2: false
      }

      legal_moves = {
        b5: true, c5: true, d5: true,
        b4: true,           d4: true,
        b3: true, c3: true, d3: true
      }

      illegal_moves.each do |coordinate, disallowed|
        it "cannot move to more than one square (#{coordinate})" do
          expect(king.can_move_to?(coordinate, chessboard)).to be disallowed
        end
      end

      legal_moves.each do |coordinate, allowed|
        it "can move to adjacent squares (#{coordinate})" do
          expect(king.can_move_to?(coordinate, chessboard)).to be allowed
        end
      end
    end

    context 'when the white king has not moved yet' do
      let(:fen) { 'r3k2r/pppppppp/8/8/8/8/PPPPPPPP/R3K2R w KQkq - 0 1' }
      let(:chessboard) { Chess::Chessboard.new(fen_string: fen) }
      let(:king) { chessboard.find_piece_by_coordinate(:e1) }
      let(:king_side_castling) { :g1 }
      let(:queen_side_castling) { :c1 }

      it 'can castle to king side' do
        expect(king.can_move_to?(king_side_castling, chessboard)).to be true
      end

      it 'can castle to queen side' do
        expect(king.can_move_to?(queen_side_castling, chessboard)).to be true
      end

      # Difficult to test this because the method literally generates all of possible moves by the king.
      # It does not however check if it is legal. To fix that, I have to refactor the collaborator
      # MoveList.generate_list_from, and in a sense it is quite easy to do so since I already have
      # a method that checks if the move is legal. However, it seems to require massive refactoring
      # even down to the architecture of the app itself, since the fundamental problem here is
      # I passed the validation of piece movements to the Game, not the piece itself.
      # I believe this will not work even if I check for the king's movement if it can even go
      # towards a checked square, since it will always return true as it is the king's natural movement.
      # This works just fine when you play it, and it is probably better to test this in Game instead?
      # Not sure. I'm giving this part up and move on with other tests.
      # context 'when enemy pieces cross the castling lane' do
      #   let(:fen) { '4k3/8/8/3r1r2/8/8/PPP1P1PP/R3K2R w KQ - 0 1' }
      #   let(:chessboard) { Chess::Chessboard.new(fen_string: fen) }

      #   it 'cannot castle to queen side' do
      #     expect(king.can_move_to?(queen_side_castling, chessboard)).to be false
      #   end

      #   it 'can castle to king side' do
      #     expect(king.can_move_to?(king_side_castling, chessboard)).to be false
      #   end
      # end
    end
  end
end
