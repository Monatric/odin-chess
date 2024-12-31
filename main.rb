require 'require_all'
require_all 'lib'

magnus = Player.new('Magnus', :white)
hikaru = Player.new('Hikaru', :black)
game = Game.new(Chessboard.new)
game.chessboard.assemble(magnus, hikaru)

def play(game)
  loop do
    game.chessboard.show
    puts "(#{game.current_turn.color}) #{game.current_turn.name} move."
    get_player_choice(game)
    # game.chessboard.in_check?(:white)
    game.switch_player!
  end
end

def move(game, player_choice)
  unless game.valid_move?(player_choice)
    puts 'Invalid move! Try again.'
    get_player_choice(game)
    return
  end
  source = player_choice.slice(0, 2).to_sym
  dest = player_choice.slice(2, 3).to_sym
  game.move_piece(source, dest)
end

def get_player_choice(game)
  show_options
  print 'Your move: '
  player_choice = gets.chomp
  if player_choice.match?(/\A[1-9]+\z/)
    run_selected_option(game, player_choice)
  else
    move(game, player_choice)
  end
end

def run_selected_option(game, player_choice)
  case player_choice.to_i
  when 1
    fen = FEN.new
    puts fen.print_fen(game.chessboard, game)
  when 2
    p game.legal_moves_of_color(:black)
  when 3
    p game.in_check?(game.current_turn.color)
  end
  get_player_choice(game)
end

def show_options
  puts "\t1: Show FEN"

  # temporary. For testing
  puts 'Testing purposes:'
  puts "\t2: Show legal moves"
  puts "\t3: Show if current player in check"
end

def show_fen
  puts fen.print_fen(game.chessboard, game)
end

fen = FEN.new
# p game.chessboard.find_coordinate_by_position([9, 9])
play(game)
# puts fen.print_fen(game.chessboard, game)
