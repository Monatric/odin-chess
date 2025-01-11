require 'require_all'
require_all 'lib'

def start(game)
  loop do
    game.chessboard.show
    puts "(#{game.current_turn_color}) #{game.current_turn_name} move."
    get_player_choice(game)
    game.switch_player!
  end
end

def move(game, player_choice)
  return invalid_move_error(game) unless game.valid_move?(player_choice)

  source = player_choice.slice(0, 2).to_sym
  dest = player_choice.slice(2, 3).to_sym

  if game.in_check?(game.current_turn_color, game.chessboard)
    handle_move_in_check(source, dest, game)
  else
    game.move_piece(source, dest, game.chessboard)
  end
end

def invalid_move_error(game)
  puts 'Invalid move! Try again.'
  get_player_choice(game)
end

def handle_move_in_check(source, dest, game)
  if game.move_avoids_check?(source, dest, game.current_turn_color)
    game.move_piece(source, dest, game.chessboard)
  else
    puts 'Your king is in check. Try again.'
    get_player_choice(game)
  end
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
    puts game.fen.generate_fen
  when 2
    puts game.legal_squares_of_color(:black)
  when 3
    puts game.in_check?(game.current_turn_color)
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

magnus = Player.new('Magnus', :white)
hikaru = Player.new('Hikaru', :black)
chessboard = Chessboard.new
game = Game.new(chessboard)

start(game)
