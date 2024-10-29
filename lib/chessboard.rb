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

  def assemble(board)
    test = Player.new('test', :white)
    board[:a1][:piece] = Pawn.new(:white, test)
    board[:h8][:piece] = Pawn.new(:white, test)
  end
end
