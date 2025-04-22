# frozen_string_literal: true

# namespace for chess classes
module Chess
  require_relative 'chess/fen'
  require_relative 'chess/game'
  require_relative 'chess/chessboard'
  Dir['chess/*.rb'].sort.each { |file| require_relative file }
  Dir['chess/fen/*.rb'].sort.each { |file| require_relative file }
  Dir['chess/pieces/*.rb'].sort.each { |file| require_relative file }

  RANK_ORDINALS = {
    first: '1',
    second: '2',
    third: '3',
    fourth: '4',
    fifth: '5',
    sixth: '6',
    seventh: '7',
    eighth: '8'
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
