# frozen_string_literal: true

Dir['lib/**/*.rb'].sort.each { |file| require_relative file }

def new_game(game)
  loop do
    game.chessboard.show
    puts "(#{game.current_turn_color}) #{game.current_turn_name} move."
    get_player_move(game)
    game.switch_player!
    end_game(game) if Chess::ThreatAnalyzer.checkmate?(game.current_turn_color, game.chessboard, game)
    game.update_fen
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
  get_player_move(game)
end

def handle_move_in_check(source, dest, game)
  move_avoids_check_result = Chess::ThreatAnalyzer.move_avoids_check?(source, dest, game)
  if move_avoids_check_result
    game.move_piece(source, dest, game.chessboard)
  else
    puts 'Your king is in check. Try again.'
    get_player_move(game)
  end
end

def get_player_move(game)
  print 'Your move: '
  player_choice = gets.chomp
  move(game, player_choice)
end

def start
  puts 'Welcome to Chess! Would you like to play a new game or load your last saved game?'
  puts "Select a number:\n\t1: New Game\n\t2: Load Game"
  player_choice = prompt_game_choice
  start_new_game if player_choice == '1'
  start_load_game if player_choice == '2'
end

def start_new_game
  # magnus = Player.new('Magnus', :white)
  # hikaru = Player.new('Hikaru', :black)
  chessboard = Chess::Chessboard.new
  game = Chess::Game.new(chessboard: chessboard)

  new_game(game)
end

def start_load_game
  game = Chess::Game.load
  new_game(game)
end

def end_game(game)
  puts "Winner is #{game.other_turn_color}"
  exit
end

def prompt_game_choice
  choice = gets.chomp
  valid_choices = %w[1 2]
  until valid_choices.any?(choice)
    puts 'Invalid choice. Try again.'
    choice = gets.chomp
  end
  choice
end

def show_fen
  puts fen.print_fen(game.chessboard, game)
end

# Start the program
start
