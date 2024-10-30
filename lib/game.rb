# class for Game that facilitates the chess game
class Game
  attr_reader :board, :player_white, :player_black, :current_turn

  def initialize(board,
                 player_white = Player.new('Magnus', :white),
                 player_black = Player.new('Hikaru', :black),
                 current_turn = player_white)
    @board = board
    @player_white = player_white
    @player_black = player_black
    @current_turn = current_turn
  end
end
