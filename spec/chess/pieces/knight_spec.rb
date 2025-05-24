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
    context 'white knight' do
      context 'when the knight is at the center' do
        let(:fen) { '6k1/8/3p4/4r3/2N5/8/1b6/6K1 w - - 0 1' }
        let(:chessboard) { Chess::Chessboard.new(fen_string: fen) }
        let(:knight) { chessboard.find_piece_by_coordinate(:c4) }

        moves = {
          a3: true, b2: true, d2: true, e3: true,
          e5: true, d6: true, b6: true, a5: true
        }

        moves.each do |coordinate, allowed|
          it "can move to #{coordinate}" do
            expect(knight.can_move_to?(coordinate, chessboard)).to be allowed
          end
        end
      end
    end
  end
end
