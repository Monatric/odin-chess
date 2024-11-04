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

  def assemble(player_white, player_black, board = @board)
    add_pawns(player_white, player_black, board)
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
    ((file.ord + col).chr + row.to_s).to_sym
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

  private

  attr_reader :board

  def add_pawns(player_white, player_black, board = @board)
    file = 'a'
    rank_two = '2'
    rank_seven = '7'
    board[:d3][:piece] = Pawn.new(player_black.color, player_black)
    until file == 'i'
      board[(file + rank_two).to_sym][:piece] = Pawn.new(player_white.color, player_white)
      board[(file + rank_seven).to_sym][:piece] = Pawn.new(player_black.color, player_black)
      file = (file.ord + 1).chr
    end
  end
end
