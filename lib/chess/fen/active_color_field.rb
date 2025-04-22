# frozen_string_literal: true

module Chess
  # class for generating the second field of FEN, responsible for showing the current turn (color)
  class ActiveColorField
    def self.generate(game)
      game.current_turn_color == :white ? 'w' : 'b'
    end
  end
end
