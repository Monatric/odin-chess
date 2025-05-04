# require 'require_all'
# require_all 'lib'
Dir['lib/*.rb'].sort.each { |file| require_relative file }
Dir['lib/chess/*.rb'].sort.each { |file| require_relative file }
Dir['lib/chess/pieces/*.rb'].sort.each { |file| require_relative file }
Dir['lib/chess/fen/*.rb'].sort.each { |file| require_relative file }
Dir['lib/helpers/*.rb'].sort.each { |file| require_relative file }

def start(game)
  loop do
    game.chessboard.show
    puts "(#{game.current_turn_color}) #{game.current_turn_name} move."
    get_player_choice(game)
    game.update_fen
    game.switch_player!
  end
end

def move(game, player_choice)
  return invalid_move_error(game) unless game.valid_move?(player_choice)

  source = player_choice.slice(0, 2).to_sym
  dest = player_choice.slice(2, 3).to_sym

  if Chess::ThreatAnalyzer.in_check?(game.current_turn_color, game.chessboard)
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
  move_avoids_check_result = Chess::ThreatAnalyzer.move_avoids_check?(source, dest, game)
  if move_avoids_check_result
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
    puts game.legal_squares_of_color(game.current_turn_color, game.chessboard)
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
chessboard = Chess::Chessboard.new
game = Chess::Game.new(chessboard: chessboard)

start(game)
