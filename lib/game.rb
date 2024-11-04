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

  def move_piece(source, dest)
    piece = chessboard.find_piece_by_coordinate(source)
    piece.move(dest, chessboard)
  end

  def valid_move?(move)
    source = move.slice(0, 2).to_sym
    dest = move.slice(2, 3).to_sym
    piece = chessboard.find_piece_by_coordinate(source)

    if piece.player.color == current_turn.color && piece.can_move_to?(dest, chessboard)
      move_piece(source, dest)
    else
      puts 'Invalid!'
      false
    end
  end
end
