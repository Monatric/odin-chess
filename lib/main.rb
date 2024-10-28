require_relative 'chessboard'
require_relative 'pieces/pawn'
require_relative 'pieces/piece'
require_relative 'player'

b = Chessboard.new
p b.assemble(b.board)
p b.board[:a1][:piece].symbol
