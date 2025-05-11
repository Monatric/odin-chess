# frozen_string_literal: true

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

    def self.load(fen_string)
      piece_placement_field = FEN.parse_piece_placement_field(fen_string)
      new(chessboard: Chessboard.from_fen(piece_placement_field), fen: fen_string)
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
      source = move.slice(0, 2).to_sym
      dest = move.slice(2, 3).to_sym

      return false unless @chessboard.valid_source_and_dest?(source, dest)
      return false unless piece_belongs_to_current_player?(source)
      return false unless piece_can_move_to?(source, dest)

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

    def piece_belongs_to_current_player?(source)
      piece = chessboard.find_piece_by_coordinate(source)
      piece && piece.color == current_turn.color
    end

    def piece_can_move_to?(source, dest)
      piece = chessboard.find_piece_by_coordinate(source)
      piece && piece.can_move_to?(dest, chessboard)
    end
  end
end
