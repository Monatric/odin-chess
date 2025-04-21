# frozen_string_literal: true

# class for generating the fifth field of FEN, responsible for showing the halfmove clock
class HalfmoveClockField
  attr_reader :halfmove_clock

  def initialize(chessboard = Chessboard.new, halfmove_clock = 0)
    @chessboard = chessboard
    @halfmove_clock = halfmove_clock
    @halfmove_clock_tracker = { piece_count: 0, pawn_coordinates: [], prev_piece_placement_field: '' }
    generate
  end

  def generate
    if @halfmove_clock_tracker[:prev_piece_placement_field] == ''
      @halfmove_clock_tracker = temp_halfmove_clock_tracker
      return @halfmove_clock
    end

    set_halfmove_clock

    @halfmove_clock_tracker = temp_halfmove_clock_tracker
    @halfmove_clock
  end

  private

  attr_writer :halfmove_clock
  attr_accessor :halfmove_clock_tracker

  def set_halfmove_clock
    temp_piece_count = temp_halfmove_clock_tracker[:piece_count]
    temp_pawn_coordinates = temp_halfmove_clock_tracker[:pawn_coordinates]
    temp_piece_placement_field = temp_halfmove_clock_tracker[:prev_piece_placement_field]
    if temp_piece_placement_field == @halfmove_clock_tracker[:prev_piece_placement_field]
      @halfmove_clock
    elsif halfmove_clock_tracker_empty? || same_halfmove_tracker?(temp_piece_count, temp_pawn_coordinates)
      @halfmove_clock += 1
    else
      @halfmove_clock = 0
    end
  end

  def same_halfmove_tracker?(temp_piece_count, temp_pawn_coordinates)
    same_pawn_coordinates?(temp_pawn_coordinates) && same_piece_count?(temp_piece_count)
  end

  def same_pawn_coordinates?(temp_pawn_coordinates)
    temp_pawn_coordinates == @halfmove_clock_tracker[:pawn_coordinates]
  end

  def same_piece_count?(temp_piece_count)
    temp_piece_count == @halfmove_clock_tracker[:piece_count]
  end

  def halfmove_clock_tracker_empty?
    @halfmove_clock_tracker[:piece_count].zero? && @halfmove_clock_tracker[:pawn_coordinates].empty?
  end

  def temp_halfmove_clock_tracker
    temp_halfmove_clock_tracker = { piece_count: 0, pawn_coordinates: [], prev_piece_placement_field: '' }
    ('a'..'h').each do |file|
      8.downto(1).each do |rank|
        coordinate = "#{file}#{rank}".to_sym
        piece = @chessboard.find_piece_by_coordinate(coordinate)

        temp_halfmove_clock_tracker[:piece_count] += 1 if piece
        temp_halfmove_clock_tracker[:pawn_coordinates] << coordinate if piece.is_a? Pawn
      end
    end
    temp_halfmove_clock_tracker[:prev_piece_placement_field] = PiecePlacementField.generate(@chessboard)
    temp_halfmove_clock_tracker
  end
end
