require_relative 'displayable'

# class for the chess board and its states
class Chessboard
  include Displayable

  def initialize(board = create)
    @board = board
    assemble
  end

  def create
    cells = {}
    file = 'a'
    rank_counter = 0
    until file == 'i'
      (1..8).each do |rank|
        notation = file + rank.to_s
        cells[notation.to_sym] = { piece: nil, position: [rank_counter, rank - 1] }
      end
      file = (file.ord + 1).chr
      rank_counter += 1
    end
    # cells.each_pair { |k, v| puts "#{k}: #{v}" }
    cells
  end

  def show
    display_board(@board)
  end

  def add_piece(coordinate, piece)
    board[coordinate][:piece] = piece
  end

  def remove_piece(coordinate)
    board[coordinate][:piece] = nil
  end

  def coordinate_exist?(coordinate)
    board.key?(coordinate)
  end

  def valid_source_and_dest?(source, dest)
    coordinate_exist?(source) && coordinate_exist?(dest)
  end

  def assemble
    add_pawns
    add_knights
    add_bishops
    add_rooks
    add_queens
    add_kings
  end

  def find_piece_by_coordinate(coordinate)
    board[coordinate][:piece]
  end

  def find_piece_by_position(position)
    coordinate = find_coordinate_by_position(position)
    board[coordinate][:piece]
  end

  def find_coordinate_by_position(position)
    col = position[0]
    row = position[1] + 1 # add 1 because of indexing
    file = 'a'
    coordinate = ((file.ord + col).chr + row.to_s).to_sym
    board.key?(coordinate) ? coordinate : nil
  end

  def current_coordinate(piece)
    board.select do |coordinate, data|
      return coordinate if data[:piece] == piece
    end
    nil
  end

  def current_position(piece)
    board.select do |_, data|
      return data[:position] if data[:piece] == piece
    end
    nil
  end

  def king_coordinate(color)
    board.select do |_, value|
      value[:piece].instance_of?(::King) && value[:piece].color == color
    end.keys.first
  end

  def find_squares_with_pieces_by_color(color)
    board.select do |_, info|
      !info[:piece].nil? && info[:piece].color == color
    end
  end

  # keys are King destination by player, the values are the rook's current and new coordinate
  def castling_rook_coordinate
     {
      g1: %i[h1 f1],
      c1: %i[a1 d1],
      g8: %i[h8 f8],
      c8: %i[a8 d8]
    }
  end

  # def castling_rook_new_coordinate(rook_coordinate)
  #   case rook_coordinate
  #   when :h1
  #     :f1
  #   when :a1
  #     :d1
  #   when :h8
  #     :f8
  #   when :a8
  #     :d8
  #   end
  # end

  private

  attr_reader :board

  def add_pawns
    file = 'a'
    rank_two = '2'
    rank_seven = '7'
    until file == 'i'
      @board[(file + rank_two).to_sym][:piece] = Pawn.new(:white)
      @board[(file + rank_seven).to_sym][:piece] = Pawn.new(:black)
      file = (file.ord + 1).chr
    end
  end

  def add_knights
    @board[:b1][:piece] = Knight.new(:white)
    @board[:g1][:piece] = Knight.new(:white)
    @board[:b8][:piece] = Knight.new(:black)
    @board[:g8][:piece] = Knight.new(:black)
  end

  def add_bishops
    @board[:c1][:piece] = Bishop.new(:white)
    @board[:f1][:piece] = Bishop.new(:white)
    @board[:c8][:piece] = Bishop.new(:black)
    @board[:f8][:piece] = Bishop.new(:black)
  end

  def add_rooks
    @board[:a1][:piece] = Rook.new(:white)
    @board[:h1][:piece] = Rook.new(:white)
    @board[:a8][:piece] = Rook.new(:black)
    @board[:h8][:piece] = Rook.new(:black)
  end

  def add_queens
    @board[:d1][:piece] = Queen.new(:white)
    @board[:d8][:piece] = Queen.new(:black)
  end

  def add_kings
    @board[:e1][:piece] = King.new(:white)
    @board[:e8][:piece] = King.new(:black)
  end
end
