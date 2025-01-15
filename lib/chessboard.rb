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

  def assemble(fen_first_field = 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPPPPPP/RNBQKBNR/')
    rank = '8'
    first_field_split = fen_first_field.split('/')
    first_field_split.each do |piece_placement_data|
      file = 'a'

      add_pieces_by_piece_placement_data(file, rank, piece_placement_data)
      
      # decrease rank number
      rank = (rank.to_i - 1).to_s
    end
  end

  def add_pieces_by_piece_placement_data(file, rank, piece_placement_data)
    # convert to chars to get individual chars into array
    piece_placement_data.chars.each do |notation|
      coordinate = (file + rank).to_sym
      
      # if the char is a number, this must be space. Use it as how many spaces (nil) must be placed
      if notation.match(/[0-9]/)
        notation.to_i.times do
          break if file == 'i'
          @board[coordinate][:piece] = nil
  
          file = (file.ord + 1).chr
          coordinate = (file + rank).to_sym
        end
      else
        @board[coordinate][:piece] = piece_notation_equivalent[notation]
        file = (file.ord + 1).chr
      end      
    end
  end

  def piece_notation_equivalent
    piece_notation_equivalent = {
      'r' => Rook.new(:black),
      'n' => Knight.new(:black),
      'b' => Bishop.new(:black),
      'q' => Queen.new(:black),
      'k' => King.new(:black),
      'p' => Pawn.new(:black),
      'R' => Rook.new(:white),
      'N' => Knight.new(:white),
      'B' => Bishop.new(:white),
      'Q' => Queen.new(:white),
      'K' => King.new(:white),
      'P' => Pawn.new(:white)
    }
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
  
  private

  attr_reader :board

end