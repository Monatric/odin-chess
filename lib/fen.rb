# class for generating, saving, loading, or getting/setting data for a valid chess position
class FEN
  def initialize(game = Game.new, chessboard = Chessboard.new)
    @game = game
    @chessboard = chessboard
    @pawn_rank_struct = add_pieces_in_pawn_rank_struct
  end

  def generate_fen
    @fen_strings = []
    @fen_strings << first_field
    @fen_strings << second_field
    @fen_strings << third_field
    fourth_field
    @fen_strings.join(' ')
  end

  private

  attr_accessor :fen_strings

  def first_field
    file = 'a'
    rank = 8
    space = 0
    first_field_array = []
    add_first_field_data(file, space, rank, first_field_array)
    first_field_array.join('')
  end

  def second_field
    @game.current_turn_color == :white ? 'w' : 'b'
  end

  def third_field
    field_string = []
    add_white_castling_availability(field_string)
    add_black_castling_availability(field_string)
    result = field_string.join('')
    result << '-' if result.empty?
    result
  end

  def fourth_field
    current_turn = second_field
    next_turn = current_turn == 'w' ? :black : :white
    # algorithm pseudocode:
    # get all the pawns location by white and black, store in a hash
    # Keys are the pawn objects, value is a hash with current coordinate,
    #   en_passantable that starts with false, if it moves 1 square then nil,
    #   if 2 then check if there's a black pawn beside it, if there is a black pawn then true, else nil
    # If the current turn is white, check black pieces if any object has en_passantable to true.
    #   Return that coordinate if true, else return hyphen '-'

    temp_pawn_rank_struct = add_pieces_in_pawn_rank_struct
    @pawn_rank_struct[next_turn].each_pair do |k, v|
    end
    temp_pawn_rank_struct[next_turn].each_pair do |k, v|
      # if value is nil, a pawn has moved. Must find if two ranks above it has the pawn
      # If it has the pawn, then check for opposing adjacent pawn, left n right, but one only needs to return true
      puts " #{k} #{v}"
      next unless v.nil?

      two_steps = (k.to_s[0] + k.to_s[1] = '4').to_sym
      two_steps_piece = @chessboard.find_piece_by_coordinate(two_steps)
      next unless !two_steps_piece.nil? && two_steps_piece.instance_of?(::Pawn)

      left_adjacent = ((two_steps.to_s.ord - 1).chr + two_steps[1]).to_sym
      right_adjacent = ((two_steps.to_s.ord + 1).chr + two_steps[1]).to_sym
      if @chessboard.coordinate_exist?(left_adjacent)
        left_adjacent_piece = @chessboard.find_piece_by_coordinate(left_adjacent)
        v[:en_passantable] = true if left_adjacent_piece.instance_of?(::Pawn) && left_adjacent_piece.color == next_turn
      elsif @chessboard.coordinate_exist?(right_adjacent)
        right_adjacent_piece = @chessboard.find_piece_by_coordinate(right_adjacent)
        if right_adjacent_piece.instance_of?(::Pawn) && right_adjacent_piece.color == next_turn
          v[:en_passantable] =
            true
        end

      end
    end
  end

  def en_passantable_square(pawn_rank_struct)
    current_turn = second_field
    next_turn = current_turn == 'w' ? :black : :white
    pawn_rank_struct[next_turn]
  end

  def add_pieces_in_pawn_rank_struct
    pawn_rank_struct = create_pawn_rank_structure
    pawn_rank_struct.map do |_, coordinates| # later rename coordinates as rank
      coordinates.map do |coordinate, _|
        piece = @chessboard.find_piece_by_coordinate(coordinate)
        next if piece.nil?

        coordinates[coordinate] = { piece: piece, en_passantable: nil }
      end
    end
    pawn_rank_struct
  end

  def create_pawn_rank_structure
    pawns = { white: {}, black: {} }
    file = 'a'
    rank = '2'
    until file == 'i'
      square = "#{file}#{rank}".to_sym
      # piece = @chessboard.find_piece_by_coordinate(square)
      # next if piece.nil? || !piece.instance_of?(::Pawn)
      # if not pawn then next
      # if nil then check if it hopped two squares, then check if it has an adjacent opposing pawn
      # pawns[piece.color][square] = piece
      color = (rank == '2' ? :white : :black)
      pawns[color][square] = nil
      file = (file.ord + 1).chr
      if square == :h2
        file = 'a'
        rank = '7'
      end
    end
    pawns
  end

  def add_white_castling_availability(field_string)
    h1_piece = @chessboard.find_piece_by_coordinate(:h1)
    a1_piece = @chessboard.find_piece_by_coordinate(:a1)
    return if king_moved?(:white)

    field_string << 'K' if h1_piece.instance_of?(::Rook) && !h1_piece.moved
    field_string << 'Q' if a1_piece.instance_of?(::Rook) && !a1_piece.moved
    field_string
  end

  def add_black_castling_availability(field_string)
    h8_piece = @chessboard.find_piece_by_coordinate(:h8)
    a8_piece = @chessboard.find_piece_by_coordinate(:a8)
    return if king_moved?(:black)

    field_string << 'k' if h8_piece.instance_of?(::Rook) && !h8_piece.moved
    field_string << 'q' if a8_piece.instance_of?(::Rook) && !a8_piece.moved
    field_string
  end

  def king_moved?(color)
    king_coordinate = @chessboard.king_coordinate(color)
    king = @chessboard.find_piece_by_coordinate(king_coordinate)
    king.moved
  end

  def add_first_field_data(file, space, rank, first_field_array)
    until rank.zero?
      add_rank_data(file, space, rank, first_field_array)
      rank -= 1
    end
  end

  def add_rank_data(file, space, rank, first_field_array)
    until file == 'i'
      coordinate = (file + rank.to_s).to_sym
      piece = @chessboard.find_piece_by_coordinate(coordinate)

      space = add_space_between_piece(piece, space, first_field_array)
      file = next_file(file)
    end
    first_field_array << space.to_s unless space.zero?
    first_field_array << '/'
  end

  def next_file(file)
    (file.ord + 1).chr
  end

  def add_space_between_piece(piece, space, first_field_array)
    if piece.nil?
      space + 1
    else
      first_field_array << space.to_s unless space.zero?
      first_field_array << piece.notation
      0
    end
  end
end
