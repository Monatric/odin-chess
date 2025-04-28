# frozen_string_literal: true

require_relative '../displayable'
require_relative 'pieces/king'

module Chess
  # class for the chess board and its states
  class Chessboard
    include Displayable

    def initialize(board: create, fen_first_field: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/')
      @board = board
      assemble(fen_first_field)
    end

    def create
      cells = {}
      rank_counter = 0
      ('a'..'h').each do |file|
        (1..8).each do |rank|
          notation = file + rank.to_s
          cells[notation.to_sym] = { piece: nil, position: [rank_counter, rank - 1] }
        end
        rank_counter += 1
      end
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

    def assemble(fen_first_field = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/')
      max_rank = 8
      first_file = 'a'
      rank_data = fen_first_field.split('/')
      rank_data.each_with_index do |piece_placement_data, current_rank|
        rank = (max_rank - current_rank).to_s
        add_pieces_by_piece_placement_data(first_file, rank, piece_placement_data)
      end
    end

    def find_piece_by_coordinate(coordinate)
      return nil unless coordinate_exist?(coordinate)

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
        value[:piece].is_a?(King) && value[:piece].color == color
      end.keys.first
    end

    def find_squares_with_pieces_by_color(color)
      board.select do |_, info|
        !info[:piece].nil? && info[:piece].color == color
      end
    end

    private

    attr_reader :board

    def add_pieces_by_piece_placement_data(first_file, rank, piece_placement_data)
      # convert to chars to get individual chars into array
      piece_placement_data.chars.each_with_index do |notation, char|
        file = (first_file.ord + char).chr
        coordinate = (file + rank).to_sym

        # if the char is a number, this must be space. Use it as how many spaces (nil) must be placed
        if notation.match(/[0-9]/)
          add_nil_pieces(file, rank, coordinate, notation)
        else
          @board[coordinate][:piece] = PieceNotation.notation_to_piece(notation)
        end
      end
    end

    def add_nil_pieces(file, rank, coordinate, notation)
      notation.to_i.times do
        @board[coordinate][:piece] = nil
        coordinate = (file + rank).to_sym
      end
    end
  end
end
