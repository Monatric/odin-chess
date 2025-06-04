# frozen_string_literal: true

module Chess
  # class for generating the sixth field of FEN, responsible for showing the number of full moves.
  class FullmoveNumberField
    attr_reader :fullmove_number

    def initialize(game, fullmove_number = 1, move_log_with_colors = [])
      @game = game
      @fullmove_number = fullmove_number.to_i
      @move_log_with_colors = move_log_with_colors
    end

    def generate
      active_color = ActiveColorField.generate(@game)
      @move_log_with_colors << active_color
      add_fullmove_number
      @fullmove_number
    end

    private

    def add_fullmove_number
      # if the array looks like [...'b', 'w'], that means a full turn has passed
      return @fullmove_number unless full_turn_complete?

      @fullmove_number += 1
      @move_log_with_colors = [] # reset
    end

    def full_turn_complete?
      black_notation = 'w'
      white_notation = 'b'

      # if the array looks like [...'b', 'w'], that means a full turn has passed
      @move_log_with_colors[-1] == black_notation && @move_log_with_colors[-2] == white_notation
    end

    attr_writer :fullmove_number
  end
end
