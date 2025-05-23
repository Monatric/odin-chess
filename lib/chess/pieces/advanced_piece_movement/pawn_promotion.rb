# frozen_string_literal: true

# require_relative '../piece'

module Chess
  # class for the pawn
  class PawnPromotion
    class << self
      extend Convertable

      def promotion_square?(pawn, dest)
        rank = dest[1].to_i
        if pawn.white?
          RANK_ORDINALS[:eighth] == rank
        elsif pawn.black?
          RANK_ORDINALS[:first] == rank
        end
      end

      def promote(pawn)
        puts 'Choose a number to select a piece:'
        puts "\t1: Queen\n\t2: Knight\n\t3: Rook\n\t4: Bishop"
        number_selected = select_number

        case number_selected
        when 1
          Chess::Queen.new(pawn.color)
        when 2
          Chess::Knight.new(pawn.color)
        when 3
          Chess::Rook.new(pawn.color, true)
        when 4
          Chess::Bishop.new(pawn.color)
        end
      end

      private

      def select_number
        number_selected = gets.chomp.to_i
        number_selections = (1..4).to_a
        until number_selections.include?(number_selected)
          puts 'Invalid input. Try again.'
          number_selected = gets.chomp.to_i
        end
        number_selected
      end
    end
  end
end
