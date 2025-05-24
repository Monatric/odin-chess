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
  end
end
