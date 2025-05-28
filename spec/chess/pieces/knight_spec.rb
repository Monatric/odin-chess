# frozen_string_literal: true

describe 'Knight functionality' do
  describe '#can_move_to?' do
    context 'when the white knight is at the center with capturable black pieces' do
      let(:fen) { '6k1/8/3p4/4r3/2N5/8/1b6/6K1 w - - 0 1' }
      let(:chessboard) { Chess::Chessboard.new(fen_string: fen) }
      let(:knight) { chessboard.find_piece_by_coordinate(:c4) }

      legal_moves = {
        a3: true, b2: true, d2: true, e3: true,
        e5: true, d6: true, b6: true, a5: true
      }

      illegal_moves = {
        b3: false, c3: false, d3: false,
        b4: false, d4: false, b5: false,
        c5: false, d5: false
      }

      legal_moves.each do |coordinate, allowed|
        it "can move like an L shape (#{coordinate})" do
          expect(knight.can_move_to?(coordinate, chessboard)).to be allowed
        end
      end

      illegal_moves.each do |coordinate, disallowed|
        it "cannot move to adjacent squares (#{coordinate})" do
          expect(knight.can_move_to?(coordinate, chessboard)).to be disallowed
        end
      end
    end

    context 'when the black knight is at the center with capturable white pieces' do
      let(:fen) { '6k1/8/3P4/4R3/2n5/8/1B6/6K1 b - - 0 1' }
      let(:chessboard) { Chess::Chessboard.new(fen_string: fen) }
      let(:knight) { chessboard.find_piece_by_coordinate(:c4) }

      legal_moves = {
        a3: true, b2: true, d2: true, e3: true,
        e5: true, d6: true, b6: true, a5: true
      }

      illegal_moves = {
        b3: false, c3: false, d3: false,
        b4: false, d4: false, b5: false,
        c5: false, d5: false
      }

      legal_moves.each do |coordinate, allowed|
        it "can move like an L shape (#{coordinate})" do
          expect(knight.can_move_to?(coordinate, chessboard)).to be allowed
        end
      end

      illegal_moves.each do |coordinate, disallowed|
        it "cannot move to adjacent squares (#{coordinate})" do
          expect(knight.can_move_to?(coordinate, chessboard)).to be disallowed
        end
      end
    end
  end
end
