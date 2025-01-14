require_relative 'piece'

# class for the pawn
class Pawn < Piece
  attr_accessor :moved, :en_passant
  attr_reader :color

  def initialize(color, moved = false, en_passant = false)
    super(color)
    @moved = moved
    @en_passant = en_passant
  end

  def notation
    @color == :white ? 'P' : 'p'
  end

  def symbol
    @color == :white ? '♙' : '♟'
  end

  def move(dest, chessboard)
    self.en_passant = true if en_passantable?(dest, chessboard)
    if dest == en_passantable_square(chessboard)
      # if dest is 3, this means white pawn is captured at fourth rank
      # else it would be 6, captured black pawn at fifth rank
      opponent_pawn_coordinate = (dest[1] == '3' ? (dest[0] + '4').to_sym : (dest[0] + '5').to_sym)
      chessboard.remove_piece(opponent_pawn_coordinate)
    end
    self.moved = true
    super(dest, chessboard)
  end

  private

  def en_passantable?(dest, chessboard)
    source = chessboard.current_coordinate(self)
    if source[1] == '2' && dest[1] == '4'
      left_adjacent = ((dest.to_s.ord - 1).chr + dest[1]).to_sym
      right_adjacent = ((dest.to_s.ord + 1).chr + dest[1]).to_sym
      left_adjacent_piece = chessboard.find_piece_by_coordinate(left_adjacent)
      right_adjacent_piece = chessboard.find_piece_by_coordinate(right_adjacent)
      (left_adjacent_piece.instance_of?(::Pawn) && left_adjacent_piece.color == :black) ||
      (right_adjacent_piece.instance_of?(::Pawn) && right_adjacent_piece.color == :black)
    end
  end


  def en_passantable_square(chessboard)
    # For ex., if :black, it should return '4' to since that's where an opposing pawn starts
    # to be en_passantable
    file = 'a'
    rank = (@color == :white ? '5' : '4')
    until file == 'i'
      coordinate = "#{file}#{rank}".to_sym
      file = (file.ord + 1).chr
      piece = chessboard.find_piece_by_coordinate(coordinate)
      if piece.instance_of?(::Pawn) && piece.en_passant == true
        # if rank is 5, meaning it's above it or 6
        # if rank is 4 then beneath it is 3
        rank_behind_pawn = (rank == '5' ? '6' : '3')
        return (coordinate[0] + rank_behind_pawn).to_sym
      end
    end
  end

  def generate_possible_moves(chessboard)
    possible_moves = []
    file = chessboard.current_coordinate(self)[0]
    rank = chessboard.current_coordinate(self)[1].to_i
    add_white_moves(file, rank, possible_moves, chessboard) if color == :white
    add_black_moves(file, rank, possible_moves, chessboard) if color == :black
    possible_moves << en_passantable_square(chessboard)

    possible_moves
  end

  def add_white_moves(file, rank, possible_moves, chessboard)
    add_white_forward_moves(file, rank, possible_moves, chessboard)
    add_white_capture_moves(file, rank, possible_moves, chessboard)
  end

  def add_black_moves(file, rank, possible_moves, chessboard)
    add_black_forward_moves(file, rank, possible_moves, chessboard)
    add_black_capture_moves(file, rank, possible_moves, chessboard)
  end

  def add_black_forward_moves(file, rank, possible_moves, chessboard)
    one_step = (file + (rank - 1).to_s).to_sym
    two_steps = (file + (rank - 2).to_s).to_sym

    possible_moves << one_step if chessboard.find_piece_by_coordinate(one_step).nil?
    return unless !moved && 
                  chessboard.find_piece_by_coordinate(one_step).nil? &&
                  chessboard.find_piece_by_coordinate(two_steps).nil?

    possible_moves << two_steps
  end

  def add_black_capture_moves(file, rank, possible_moves, chessboard)
    left_capture = calculate_square(file, rank - 1, -1)
    right_capture = calculate_square(file, rank - 1, 1)

    down_left = chessboard.find_piece_by_coordinate(left_capture) if chessboard.coordinate_exist?(left_capture)
    down_right = chessboard.find_piece_by_coordinate(right_capture) if chessboard.coordinate_exist?(right_capture)

    possible_moves << left_capture if capturable_by_black?(down_left)
    possible_moves << right_capture if capturable_by_black?(down_right)
  end

  def add_white_forward_moves(file, rank, possible_moves, chessboard)
    one_step = (file + (rank + 1).to_s).to_sym
    two_steps = (file + (rank + 2).to_s).to_sym

    possible_moves << one_step if chessboard.find_piece_by_coordinate(one_step).nil?
    # pawn cannot move two steps if there is a piece or has moved
    return unless !moved &&
           chessboard.find_piece_by_coordinate(one_step).nil? &&
           chessboard.find_piece_by_coordinate(two_steps).nil?
      
      possible_moves << two_steps
  end

  def add_white_capture_moves(file, rank, possible_moves, chessboard)
    left_capture = calculate_square(file, rank + 1, -1)
    right_capture = calculate_square(file, rank + 1, 1)

    up_left = chessboard.find_piece_by_coordinate(left_capture) if chessboard.coordinate_exist?(left_capture)
    up_right = chessboard.find_piece_by_coordinate(right_capture) if chessboard.coordinate_exist?(right_capture)

    possible_moves << left_capture if capturable_by_white?(up_left)
    possible_moves << right_capture if capturable_by_white?(up_right)
  end
end
