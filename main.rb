require 'require_all'
require_all 'lib'

magnus = Player.new('Magnus', :white)
hikaru = Player.new('Hikaru', :black)
game = Game.new(Chessboard.new)
game.chessboard.assemble(magnus, hikaru)

def play(game)
  loop do
    game.chessboard.show
    move = select_move(game)
    source = move.slice(0, 2).to_sym
    dest = move.slice(2, 3).to_sym
    game.move_piece(source, dest)
    game.switch_player!
  end
end

def select_move(game)
  puts "(#{game.current_turn.color}) #{game.current_turn.name} move."
  print 'Your move: '
  player_move = gets.chomp
  until game.valid_move?(player_move)
    print 'Invalid move! Try again: '
    player_move = gets.chomp
  end
  player_move
end

fen = FEN.new
# p game.chessboard.find_coordinate_by_position([9, 9])
play(game)
# puts fen.print_fen(game.chessboard, game)
