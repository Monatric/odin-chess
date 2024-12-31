# class for pieces of chess
class Piece
  # keys are King destination by player, the values are the rook's coordinates
  CASTLING_ROOK_COORDINATE = {
      g1: :h1,
      c1: :a1,
      g8: :h8,
      c8: :a8
  }

  attr_reader :color, :player

  def initialize(color = nil, player = nil)
    @color = color
    @player = player
  end

  def notation
    raise NotImplementedError, 'subclasses must have this method'
  end

  def symbol
    raise NotImplementedError, 'subclasses must have this method'
  end

  def move(dest, chessboard)
    source = chessboard.current_coordinate(self)
    p self.class.name
    chessboard.remove_piece(source)
    chessboard.add_piece(dest, self)
  end

  def castle(dest, chessboard)
    source = chessboard.current_coordinate(self)
    # p self.class.name
    chessboard.remove_piece(source)
    chessboard.add_piece(dest, self)
    
    rook = chessboard.find_piece_by_coordinate(CASTLING_ROOK_COORDINATE[dest])
    rook_coordinate = chessboard.current_coordinate(rook)
    chessboard.remove_piece(rook_coordinate)
    
    rook_new_coordinate = castling_rook_new_coordinate(rook_coordinate)
    chessboard.add_piece(rook_new_coordinate, rook)
  end

  def calculate_square(file, rank, file_offset)
    ((file.ord + file_offset).chr + rank.to_s).to_sym
  end

  def capturable_by_white?(square)
    !square.nil? && square.color == :black
  end

  def capturable_by_black?(square)
    !square.nil? && square.color == :white
  end

  def same_color_in_coordinate?(coordinate, chessboard)
    piece = chessboard.find_piece_by_coordinate(coordinate)
    return false if piece.nil?

    piece.color == color
  end

  def legal_moves(chessboard)
    calculate_possible_moves(chessboard)
  end

  private

  def castling_rook_new_coordinate(rook_coordinate)
    case rook_coordinate
    when :h1
      return :f1
    when :a1
      return :d1
    when :h8
      return :f8
    when :a8
      return :d8
    end
  end
end
