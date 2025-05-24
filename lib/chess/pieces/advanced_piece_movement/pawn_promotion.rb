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

      def select_promotion_piece(color, dup: false)
        return Chess::Queen.new(color) if dup

        puts 'Choose a number to select a piece:'
        puts "\t1: Queen\n\t2: Knight\n\t3: Rook\n\t4: Bishop"
        number_selected = select_number

        case number_selected
        when 1 then Chess::Queen.new(color)
        when 2 then Chess::Knight.new(color)
        when 3 then Chess::Rook.new(color, true)
        when 4 then Chess::Bishop.new(color)
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
