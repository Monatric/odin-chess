# class for pieces of chess
class Piece
  attr_reader :color

  def initialize(color = nil)
    @color = color
  end

  def notation
    raise NotImplementedError, 'subclasses must have this method'
  end

  def symbol
    raise NotImplementedError, 'subclasses must have this method'
  end

  def move(dest, chessboard)
    source = chessboard.current_coordinate(self)
    chessboard.remove_piece(source)
    chessboard.add_piece(dest, self)
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

  def possible_moves(chessboard)
    generate_possible_moves(chessboard)
  end

  def can_move_to?(dest, chessboard)
    possible_moves(chessboard).include?(dest)
  end

  private

  def add_moves(file, rank, possible_moves, chessboard)
    self.class::MOVE_OPTIONS.each do |option|
      piece_move = [file, rank]
      calculate_piece_options(possible_moves, chessboard, piece_move, option)
    end
  end

  # only works for Rooks, Bishops, and Queens
  def calculate_piece_options(possible_moves, chessboard, piece_move, option)
    loop do
      piece_move = [piece_move[0] + option[0], piece_move[1] + option[1]]
      coordinate = chessboard.find_coordinate_by_position(piece_move)
      break if coordinate.nil?

      if chessboard.find_piece_by_coordinate(coordinate).nil?
        possible_moves << coordinate
      elsif same_color_in_coordinate?(coordinate, chessboard)
        break
      elsif !same_color_in_coordinate?(coordinate, chessboard)
        possible_moves << coordinate
        break
      end
    end
  end

  def generate_possible_moves(chessboard)
    possible_moves = []
    position = chessboard.current_position(self)
    return possible_moves if chessboard.find_coordinate_by_position(position).nil? # possibly useless?

    file = position[0]
    rank = position[1]
    add_moves(file, rank, possible_moves, chessboard)

    possible_moves
  end
end
