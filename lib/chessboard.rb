require_relative 'displayable'

# class for the chess board and its states
class Chessboard
  include Displayable

  attr_reader :board

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
    display_board(board)
  end

  def assemble(board, player_white, player_black)
    add_pawns(board, player_white, player_black)
  end

  private

  def add_pawns(board, player_white, player_black)
    file = 'a'
    rank_two = '2'
    rank_seven = '7'
    until file == 'i'
      board[(file + rank_two).to_sym][:piece] = Pawn.new(player_white.color, player_white)
      board[(file + rank_seven).to_sym][:piece] = Pawn.new(player_black.color, player_black)
      file = (file.ord + 1).chr
    end
  end
end
