# module for displaying CLI messages
module Displayable
  def display_board(board)
    puts '   ┌───┬───┬───┬───┬───┬───┬───┬───┐'
    loop_through_board_hash(board)
    puts '   └───┴───┴───┴───┴───┴───┴───┴───┘'
    puts '     a   b   c   d   e   f   g   h'
  end

  private

  def loop_through_board_hash(board)
    8.downto(1) do |rank|
      print "#{rank}  "
      ('a'..'h').each do |file|
        piece = board[(file + rank.to_s).to_sym][:piece]
        print "│ #{piece.nil? ? ' ' : piece.symbol} "
      end
      puts '│'
      puts '   ├───┼───┼───┼───┼───┼───┼───┼───┤' unless rank == 1
    end
  end
end
# ┫ ┛ ┗ ┴ ┬ ┘ └ ┐ ┌ ─ ┼ ┻ ╋ ┣ ┏ ┓ ┤ ├ ┃
