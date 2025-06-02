# frozen_string_literal: true

Dir['lib/**/*.rb'].sort.each { |file| require_relative file }

def new_game(game)
  loop do
    game.chessboard.show
    end_game(game) if game.game_over?
    puts show_options
    puts "It is #{game.current_turn_color}'s turn"
    get_player_move(game)
    game.switch_player!
    game.update_fen
  end
end

def show_options
  <<~HEREDOC

    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      Additional options. Type the quoted option to use:
        "i" => See instructions
        "save" => Save game
        "exit" => Exit game
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  HEREDOC
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

def instructions
  <<~HEREDOC

    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      To move a piece, look at the files, which are letters a-h, and the ranks, which are 1-8.
      Then, you must type the coordinate of the piece you want to move and its destination.
      For example, I want to move the pawn from "e2" to "e4", thus you must enter "e2e4"
      without spacing.

      In summary, the format is source and destination coordinate, leading the file first
      and then the rank, such as "a1a5", "c1f4", "g1f3".
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  HEREDOC
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

  case player_choice
  when 'i'
    puts instructions
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

def show_fen
  puts fen.print_fen(game.chessboard, game)
end

# Start the program
start
