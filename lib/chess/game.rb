# frozen_string_literal: true

require 'yaml'

module Chess
  # class for Game that facilitates the chess game
  class Game
    attr_reader :chessboard, :player_white, :player_black, :fen

    def initialize(chessboard: Chessboard.new,
                   player_white: Player.new('Magnus', :white),
                   player_black: Player.new('Hikaru', :black),
                   current_turn: player_white,
                   fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w KQkq - 0 1')
      @chessboard = chessboard
      @player_white = player_white
      @player_black = player_black
      @current_turn = current_turn
      @fen = FEN.new(game: self, chessboard: @chessboard, notation: fen)
    end

    def self.load
      saved_game = YAML.load_file('saved_game.yml', permitted_classes: [Player, FEN, Symbol])
      data = saved_game_data_to_hash(saved_game)
      chessboard = Chessboard.from_fen(data[:fen])
      new(chessboard: chessboard,
          player_white: data[:player_white],
          player_black: data[:player_black],
          current_turn: data[:current_turn],
          fen: data[:fen])
    end

    def self.saved_game_data_to_hash(saved_game) # rubocop:disable Metrics/MethodLength
      fen = saved_game[:fen]

      piece_placement_field = FEN.parse_piece_placement_field(fen)
      active_color_field = FEN.parse_active_color_field(fen)

      player_white = saved_game[:player_white]
      player_black = saved_game[:player_black]
      current_turn = (active_color_field == 'w' ? player_white : player_black)
      {
        piece_placement_field: piece_placement_field,
        player_white: player_white,
        player_black: player_black,
        current_turn: current_turn,
        fen: fen
      }
    end

    private_class_method :saved_game_data_to_hash

    def save_game
      data = { player_white: @player_white, player_black: @player_black, fen: @fen.notation }
      yaml_string = YAML.dump(data)
      File.write('saved_game.yml', yaml_string)
    end

    def update_fen
      @fen.generate_fen
    end

    def move_piece(source, dest, chessboard, dup: false)
      piece = chessboard.find_piece_by_coordinate(source)
      move_validator = MoveValidator.new(source: source, dest: dest, game: self)

      if move_validator.move_is_castling?(source, dest)
        piece.castle(dest, chessboard)
      elsif move_validator.move_is_promotion?(piece, dest)
        piece.promote(dest, chessboard, dup: dup)
      else
        piece.move(dest, chessboard)
      end
    end

    def switch_player!
      self.current_turn = (current_turn == player_white ? player_black : player_white)
    end

    def current_turn_color
      @current_turn.color
    end

    def current_turn_name
      @current_turn.name
    end

    def other_turn_color
      @current_turn == @player_white ? :black : :white
    end

    private

    attr_accessor :current_turn
  end
end
