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

    def self.load(fen_string = nil)
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

    def save_game
      players = { player_white: @player_white, player_black: @player_black, fen: @fen.notation }
      yaml_string = YAML.dump(players)
      File.write('saved_game.yml', yaml_string)
    end

    def update_fen
      @fen.generate_fen
    end

    def move_piece(source, dest, chessboard)
      determine_move_action(source, dest, chessboard)
    end

    def switch_player!
      self.current_turn = (current_turn == player_white ? player_black : player_white)
    end

    def valid_move?(move)
      castling_notations = %w[e1g1 e1c1 e8g8 e8c8]
      source = move.slice(0, 2).to_sym
      dest = move.slice(2, 3).to_sym

      return false unless @chessboard.valid_source_and_dest?(source, dest)
      return false unless piece_belongs_to_current_player?(source)
      return false unless piece_can_move_to?(source, dest)
      return false if castling_notations.include?(source.to_s + dest.to_s) && !valid_castling?(source, dest)

      true
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

    def determine_move_action(source, dest, chessboard)
      castling_notations = %w[e1g1 e1c1 e8g8 e8c8]
      piece = chessboard.find_piece_by_coordinate(source)

      if castling_notations.include?(source.to_s + dest.to_s)
        piece.castle(dest, chessboard)
      else
        piece.move(dest, chessboard)
      end
    end

    def valid_castling?(source, dest)
      dest_to_rook_coord = { c1: :a1, g1: :h1, c8: :a8, g8: :h8 }
      rook_coord = dest_to_rook_coord[dest]
      king = chessboard.find_piece_by_coordinate(source)
      rook = chessboard.find_piece_by_coordinate(rook_coord)
      king.castleable? && rook&.castleable?
    end

    def piece_belongs_to_current_player?(source)
      piece = chessboard.find_piece_by_coordinate(source)
      piece && piece.color == current_turn_color
    end

    def piece_can_move_to?(source, dest)
      piece = chessboard.find_piece_by_coordinate(source)
      piece && piece.can_move_to?(dest, chessboard)
    end
  end
end
