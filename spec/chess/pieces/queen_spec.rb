# frozen_string_literal: true

require_relative '../../../lib/chess/pieces/pawn'
require_relative '../../../lib/chess/pieces/rook'
require_relative '../../../lib/chess/pieces/knight'
require_relative '../../../lib/chess/pieces/bishop'
require_relative '../../../lib/chess/pieces/king'
require_relative '../../../lib/chess/pieces/queen'
require_relative '../../../lib/chess/piece'

require_relative '../../../lib/player'
require_relative '../../../lib/chess/chessboard/chessboard_assembler'
require_relative '../../../lib/chess/chessboard'
require_relative '../../../lib/helpers/threat_analyzer'
require_relative '../../../lib/helpers/move_list'
require_relative '../../../lib/chess'

describe 'Queen functionality' do
  describe '#can_move_to?' do
    context 'when the white queen is at the center with capturable black pieces' do
      let(:fen) { '5k2/2b5/4r3/8/2Q2p2/8/8/6K1 w - - 0 1' }
      let(:chessboard) { Chess::Chessboard.new(fen_string: fen) }
      let(:queen) { chessboard.find_piece_by_coordinate(:c4) }

      illegal_moves = {
        a3: false, b2: false, d2: false, e3: false,
        e5: false, d6: false, b6: false, a5: false
      }

      legal_horizontal_moves = {
        a4: true, b4: true, d4: true, e4: true, f4: true
      }

      legal_vertical_moves = {
        c1: true, c2: true, c3: true, c5: true, c6: true, c7: true
      }

      legal_diagonal_moves = {
        a2: true, b3: true, d5: true, e6: true,
        a6: true, b5: true, d3: true, e2: true
      }

      illegal_moves.each do |coordinate, disallowed|
        it "cannot move to adjacent squares (#{coordinate})" do
          expect(queen.can_move_to?(coordinate, chessboard)).to be disallowed
        end
      end

      context 'when the queen wants to move horizontally' do
        legal_horizontal_moves.each do |coordinate, allowed|
          it "can move horizontally (#{coordinate})" do
            expect(queen.can_move_to?(coordinate, chessboard)).to be allowed
          end
        end
      end

      context 'when the queen wants to move vertically' do
        legal_vertical_moves.each do |coordinate, allowed|
          it "can move vertically (#{coordinate})" do
            expect(queen.can_move_to?(coordinate, chessboard)).to be allowed
          end
        end
      end

      context 'when the queen wants to move diagonally' do
        legal_diagonal_moves.each do |coordinate, allowed|
          it "can move diagonally (#{coordinate})" do
            expect(queen.can_move_to?(coordinate, chessboard)).to be allowed
          end
        end
      end
    end
  end
end
