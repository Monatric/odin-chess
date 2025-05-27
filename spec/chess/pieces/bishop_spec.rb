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

describe 'Bishop functionality' do
  describe '#can_move_to?' do
    context 'when the white bishop is at the center with capturable black pieces' do
      let(:fen) { '5k2/2b5/4r3/8/2B2p2/8/8/6K1 w - - 0 1' }
      let(:chessboard) { Chess::Chessboard.new(fen_string: fen) }
      let(:bishop) { chessboard.find_piece_by_coordinate(:c4) }

      illegal_moves = {
        a3: false, b2: false, d2: false, e3: false,
        e5: false, d6: false, b6: false, a5: false
      }

      illegal_horizontal_moves = {
        a4: false, b4: false, d4: false, e4: false, f4: false
      }

      illegal_vertical_moves = {
        c1: false, c2: false, c3: false, c5: false, c6: false, c7: false
      }

      legal_diagonal_moves = {
        a2: true, b3: true, d5: true, e6: true,
        a6: true, b5: true, d3: true, e2: true
      }

      illegal_moves.each do |coordinate, disallowed|
        it "cannot move to adjacent squares (#{coordinate})" do
          expect(bishop.can_move_to?(coordinate, chessboard)).to be disallowed
        end
      end

      context 'when the bishop wants to move horizontally' do
        illegal_horizontal_moves.each do |coordinate, allowed|
          it "cannot move horizontally (#{coordinate})" do
            expect(bishop.can_move_to?(coordinate, chessboard)).to be allowed
          end
        end
      end

      context 'when the bishop wants to move vertically' do
        illegal_vertical_moves.each do |coordinate, allowed|
          it "cannot move vertically (#{coordinate})" do
            expect(bishop.can_move_to?(coordinate, chessboard)).to be allowed
          end
        end
      end

      context 'when the bishop wants to move diagonally' do
        legal_diagonal_moves.each do |coordinate, allowed|
          it "can move diagonally (#{coordinate})" do
            expect(bishop.can_move_to?(coordinate, chessboard)).to be allowed
          end
        end
      end
    end
  end
end
