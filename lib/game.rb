# class for Game that facilitates the chess game
class Game
  attr_reader :chessboard, :player_white, :player_black, :current_turn

  def initialize(chessboard,
                 player_white = Player.new('Magnus', :white),
                 player_black = Player.new('Hikaru', :black),
                 current_turn = player_white)
    @chessboard = chessboard
    @player_white = player_white
    @player_black = player_black
    @current_turn = current_turn
  end
end
