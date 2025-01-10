require_relative 'displayable'

# class for the chess board and its states
class Chessboard
  include Displayable

  def initialize(board = create)
    @board = board
  end

  def create
    cells = {}
    file = 'a'
    rank_counter = 0
    until file == 'i'
      (1..8).each do |rank|
        notation = file + rank.to_s
        cells[notation.to_sym] = { piece: nil, player: nil, position: [rank_counter, rank - 1] }
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

  def assemble(player_white, player_black, board = @board)
    add_pawns(player_white, player_black, board)
    add_knights(player_white, player_black, board)
    add_bishops(player_white, player_black, board)
    add_rooks(player_white, player_black, board)
    add_queens(player_white, player_black, board)
    add_kings(player_white, player_black, board)
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

  def add_pawns(player_white, player_black, board = @board)
    file = 'a'
    rank_two = '2'
    rank_seven = '7'
    until file == 'i'
      board[(file + rank_two).to_sym][:piece] = Pawn.new(player_white.color, player_white)
      board[(file + rank_seven).to_sym][:piece] = Pawn.new(player_black.color, player_black)
      file = (file.ord + 1).chr
    end
  end

  def add_knights(player_white, player_black, board = @board)
    board[:b1][:piece] = Knight.new(player_white.color, player_white)
    board[:g1][:piece] = Knight.new(player_white.color, player_white)
    board[:b8][:piece] = Knight.new(player_black.color, player_black)
    board[:g8][:piece] = Knight.new(player_black.color, player_black)
  end

  def add_bishops(player_white, player_black, board)
    board[:c1][:piece] = Bishop.new(player_white.color, player_white)
    board[:f1][:piece] = Bishop.new(player_white.color, player_white)
    board[:c8][:piece] = Bishop.new(player_black.color, player_black)
    board[:f8][:piece] = Bishop.new(player_black.color, player_black)
  end

  def add_rooks(player_white, player_black, board)
    board[:a1][:piece] = Rook.new(player_white.color, player_white)
    board[:h1][:piece] = Rook.new(player_white.color, player_white)
    board[:a8][:piece] = Rook.new(player_black.color, player_black)
    board[:h8][:piece] = Rook.new(player_black.color, player_black)
  end

  def add_queens(player_white, player_black, board)
    board[:d1][:piece] = Queen.new(player_white.color, player_white)
    board[:d8][:piece] = Queen.new(player_black.color, player_black)
  end

  def add_kings(player_white, player_black, board)
    board[:e1][:piece] = King.new(player_white.color, player_white)
    board[:e8][:piece] = King.new(player_black.color, player_black)
  end
end
