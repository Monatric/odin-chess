# class for Game that facilitates the chess game
class Game
  CASTLING_NOTATIONS = %w[e1g1 e1c1 e8g8 e8c8]

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
    if CASTLING_NOTATIONS.include?(source.to_s + dest.to_s)
      piece.castle(dest, chessboard)
      return
    end
    piece.move(dest, chessboard)
  end

  def switch_player!
    self.current_turn = (current_turn == player_white ? player_black : player_white)
  end

  def valid_move?(move)
    source = move.slice(0, 2).to_sym
    dest = move.slice(2, 3).to_sym

    return false unless valid_coordinate?(source, dest)
    return false unless piece_belongs_to_current_player?(source)
    return false unless piece_can_move_to?(source, dest)

    true
  end

  private

  def valid_coordinate?(source, dest)
    chessboard.coordinate_exist?(source) && chessboard.coordinate_exist?(dest)
  end

  def piece_belongs_to_current_player?(source)
    piece = chessboard.find_piece_by_coordinate(source)
    piece && piece.player.color == current_turn.color
  end

  def piece_can_move_to?(source, dest)
    piece = chessboard.find_piece_by_coordinate(source)
    piece && piece.can_move_to?(dest, chessboard)
  end
end
