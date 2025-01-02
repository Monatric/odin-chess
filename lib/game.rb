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

  def covered_squares_of_color(color)
    squares_with_pieces = @chessboard.find_squares_with_pieces_by_color(color)
    squares_with_pieces.map do |_, info|
      info[:piece].possible_moves(@chessboard)
    end.flatten
  end

  def legal_squares_of_color(color)
    # color parameter is usually the current turn. Might be confusing what it means by
    # current_turn in the variable. Not sure what's the best design here.
    king_coordinate = @chessboard.king_coordinate(color)
    opponent_covered_squares = covered_squares_of_color(color == :white ? :black : :white)
    current_turn_covered_squares = covered_squares_of_color(color)
    current_turn_covered_squares.map do |current_turn_square|
      current_turn_square unless current_turn_square == opponent_covered_squares.any?(king_coordinate)
    end
  end

  def in_check?(color)
    # color parameter is usually the current turn. Might be confusing what it means by
    # current_turn in the variable. Not sure what's the best design here.
    king_coordinate = @chessboard.king_coordinate(color)
    opponent_covered_squares = covered_squares_of_color(color == :white ? :black : :white)
    opponent_covered_squares.any? { |coordinate| coordinate == king_coordinate }
  end

  def undo(source, dest)
    piece = chessboard.find_piece_by_coordinate(dest)
    piece.move(source, @chessboard)
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
