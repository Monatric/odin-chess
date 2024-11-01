# class for Game that facilitates the chess game
class Game
  attr_reader :chessboard, :player_white, :player_black, :current_turn, :board

  def initialize(chessboard,
                 player_white = Player.new('Magnus', :white),
                 player_black = Player.new('Hikaru', :black),
                 current_turn = player_white)
    @chessboard = chessboard
    @player_white = player_white
    @player_black = player_black
    @current_turn = current_turn
    @board = chessboard.board
  end

  def move_piece(source, dest)
    piece = board[source][:piece]
    piece.move(dest)
  end

  def valid_move?(move)
    source = move.slice(0, 2).to_sym
    dest = move.slice(2, 3).to_sym
    piece = board[source][:piece]

    if piece.player.color == current_turn.color && piece.can_move_to?(dest)
      move_piece(source, dest)
    else
      puts 'Invalid!'
      false
    end
  end
end
