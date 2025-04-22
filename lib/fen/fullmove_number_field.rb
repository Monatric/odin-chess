# frozen_string_literal: true

# class for generating the sixth field of FEN, responsible for showing the number of full moves.
class FullmoveNumberField
  attr_reader :fullmove_number

  def initialize(game, fullmove_number = 1, move_log_with_colors = [])
    @game = game
    @fullmove_number = fullmove_number
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
    black_notation = 'w'
    white_notation = 'b'

    # if the array looks like [...'b', 'w'], that means a full turn has passed
    unless @move_log_with_colors[-1] == black_notation && @move_log_with_colors[-2] == white_notation
      return @fullmove_number
    end

    @fullmove_number += 1
    @move_log_with_colors = [] # reset
  end

  attr_writer :fullmove_number
end
