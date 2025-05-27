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
  end
end
