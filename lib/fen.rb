# frozen_string_literal: true

# class for generating, saving, loading, or getting/setting data for a valid chess position
class FEN
  def initialize(game = Game.new, chessboard = Chessboard.new, halfmove_clock = 0)
    @game = game
    @chessboard = chessboard
    @halfmove_clock = halfmove_clock
    @halfmove_clock_tracker = { piece_count: 0, pawn_coordinates: [], prev_piece_placement_field: '' }
  end

  def generate_fen
    @fen_strings = []
    @fen_strings << PiecePlacementField.generate(@chessboard)
    @fen_strings << ActiveColorField.generate(@game)
    @fen_strings << CastlingAvailabilityField.generate(@chessboard)
    @fen_strings << en_passant_field
    @fen_strings << halfmove_clock_field
    @fen_strings.join(' ')
  end

  private

  attr_accessor :fen_strings

  def en_passant_field
    no_en_passant_square = '-'
    result = nil
    # check all files of the given rank to find out if a pawn is en passantable
    ('a'..'h').each do |file|
      5.downto(4).each do |rank|
        coordinate = "#{file}#{rank}".to_sym
        piece = @chessboard.find_piece_by_coordinate(coordinate)
        en_passantable_square = piece&.en_passantable_square(@chessboard) if piece.respond_to?(:en_passant_signal)
        result = en_passantable_square unless en_passantable_square.nil?
      end
    end
    result = (result.nil? ? no_en_passant_square : result) # default hyphen, no en passant square
  end

  def halfmove_clock_field
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

    temp_piece_count = temp_halfmove_clock_tracker[:piece_count]
    temp_pawn_coordinates = temp_halfmove_clock_tracker[:pawn_coordinates]
    temp_piece_placement_field = temp_halfmove_clock_tracker[:prev_piece_placement_field]

    if @halfmove_clock_tracker[:prev_piece_placement_field] == ''
      @halfmove_clock_tracker = temp_halfmove_clock_tracker

      return @halfmove_clock
    end

    if temp_piece_placement_field == @halfmove_clock_tracker[:prev_piece_placement_field]
      @halfmove_clock
    elsif halfmove_clock_tracker_empty? || same_halfmove_tracker?(temp_piece_count, temp_pawn_coordinates)
      @halfmove_clock += 1
    else
      @halfmove_clock = 0
    end

    @halfmove_clock_tracker = temp_halfmove_clock_tracker
    @halfmove_clock
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
end
