# frozen_string_literal: true

Dir['lib/**/*.rb'].sort.each { |file| require_relative file }

def game_loop(game)
  loop do
    system 'clear'

    puts Displayable.show_options
    game.chessboard.show
    end_game(game) if game.game_over?
    get_player_move(game)
    game.repetition_tracker.update
    game.switch_player!
    game.update_fen
  end
end

def move(game, player_choice)
  source = player_choice.slice(0, 2).to_sym
  dest = player_choice.slice(2, 3).to_sym
  move_validator = Chess::MoveValidator.new(source: source, dest: dest, game: game)

  return invalid_move_error(game) unless move_validator.valid_move?

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
  puts "It is #{game.current_turn_color}'s turn"
  print 'Your move: '
  player_choice = gets.chomp

  case player_choice
  when 'i'
    puts Displayable.instructions
    get_player_move(game)
  when 'save'
    game.save_game
    puts 'Saved successfully!'
    get_player_move(game)
  when 'exit' then exit
  else move(game, player_choice)
  end
end

def start
  puts 'Welcome to Chess! Would you like to play a new game or load your last saved game?'
  puts "Select a number:\n\t1: New Game\n\t2: Load Game"
  player_choice = prompt_game_choice
  start_new_game if player_choice == '1'
  start_load_game if player_choice == '2'
end

def start_new_game
  chessboard = Chess::Chessboard.new
  game = Chess::Game.new(chessboard: chessboard)

  game_loop(game)
end

def start_load_game
  game = Chess::Game.load
  game_loop(game)
end

def end_game(game)
  if game.status[:result] == :checkmate
    puts "Checkmate! The winner is #{game.status[:winner]}."
  elsif game.status[:result] == :draw
    puts 'Game is drawn!'
  end
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

# Start the program
start
