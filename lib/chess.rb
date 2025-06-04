# frozen_string_literal: true

# namespace for chess classes
module Chess
  require_relative 'chess/fen'
  require_relative 'chess/game'
  require_relative 'chess/chessboard'
  require_relative 'chess/piece'

  require_relative 'chess/chessboard/chessboard_assembler'

  require_relative 'chess/fen/active_color_field'
  require_relative 'chess/fen/castling_availability_field'
  require_relative 'chess/fen/en_passant_field'
  require_relative 'chess/fen/fullmove_number_field'
  require_relative 'chess/fen/halfmove_clock_field'
  require_relative 'chess/fen/piece_placement_field'

  require_relative 'chess/pieces/bishop'
  require_relative 'chess/pieces/king'
  require_relative 'chess/pieces/knight'
  require_relative 'chess/pieces/pawn'
  require_relative 'chess/pieces/queen'
  require_relative 'chess/pieces/rook'
  require_relative 'chess/pieces/advanced_piece_movement/king_castling'
  require_relative 'chess/pieces/advanced_piece_movement/pawn_en_passant'
  require_relative 'chess/pieces/advanced_piece_movement/pawn_promotion'

  require_relative 'helpers/move_list'
  require_relative 'helpers/move_validator'
  require_relative 'helpers/threat_analyzer'
  require_relative 'helpers/threefold_repetition_tracker'

  require_relative 'displayable'
  require_relative 'player'

  RANK_ORDINALS = {
    first: 1,
    second: 2,
    third: 3,
    fourth: 4,
    fifth: 5,
    sixth: 6,
    seventh: 7,
    eighth: 8
  }.freeze

  FILE_ORDINALS = {
    first: 'a',
    second: 'b',
    third: 'c',
    fourth: 'd',
    fifth: 'e',
    sixth: 'f',
    seventh: 'g',
    eighth: 'h'
  }.freeze
end
