require_relative 'chessboard'
require_relative 'pieces/pawn'
require_relative 'pieces/piece'
require_relative 'player'
require_relative 'game'
require_relative 'displayable'

# b = Chessboard.new
# magnus = Player.new('Magnus', :white)
# hikaru = Player.new('Hikaru', :black)
g = Game.new(Chessboard.new)
board = g.chessboard
board.assemble(g.player_white, g.player_black)
board.show

print 'Your move: '
player_move = gets.chomp
p player_move
p g.valid_move?(player_move)
board.show
