# frozen_string_literal: true

require_relative '../displayable'
require_relative 'pieces/king'

module Chess
  # class for the chess board and its states
  class Chessboard
    include Convertable
    include Displayable

    def initialize(board: create, fen_string: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w KQkq - 0 1')
      @board = board
      assemble(fen_string)
    end

    def self.from_fen(fen_string)
      # fen_string = FEN.parse_piece_placement_field(fen_string)
      new(fen_string: fen_string)
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

    def assemble(fen_string)
      ca = ChessboardAssembler.new(board_properties: @board, chessboard: self)
      piece_placement_field = FEN.parse_piece_placement_field(fen_string)
      rank_data = piece_placement_field.split('/')

      rank_data.each_with_index do |piece_placement_data, current_rank|
        rank = (RANK_ORDINALS[:eighth] - current_rank).to_s
        ca.add_pieces_by_piece_placement_data(FILE_ORDINALS[:first],
                                              rank,
                                              piece_placement_data,
                                              fen_string)
      end

      ca.modify_en_passant_signal(fen_string)
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
  end
end
