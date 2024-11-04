# class for Game that facilitates the chess game
class Game
  attr_accessor :current_turn
  attr_reader :chessboard, :player_white, :player_black

  def initialize(chessboard,
                 player_white = Player.new('Magnus', :white),
                 player_black = Player.new('Hikaru', :black),
                 current_turn = player_white)
    @chessboard = chessboard
    @player_white = player_white
    @player_black = player_black
    @current_turn = current_turn
  end

  def move_piece(source, dest)
    piece = chessboard.find_piece_by_coordinate(source)
    piece.move(dest, chessboard)
  end

  def switch_player!
    self.current_turn = (current_turn == player_white ? player_black : player_white)
  end

  def valid_string?(source, dest)
    true if chessboard.coordinate_exist?(source) || chessboard.coordinate_exist?(dest)
  end

  def valid_move?(move)
    source = move.slice(0, 2).to_sym
    dest = move.slice(2, 3).to_sym
    piece = chessboard.find_piece_by_coordinate(source)

    return false unless valid_string?(source, dest)
    return false unless piece.player.color == current_turn.color
    return false unless piece.can_move_to?(dest, chessboard)

    true
  end
end
