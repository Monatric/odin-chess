# module for displaying CLI messages
module Displayable
  def self.show_options
    <<~HEREDOC
  
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Additional options. Type the quoted option to use:
          "i" => See instructions
          "save" => Save game
          "exit" => Exit game
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
    HEREDOC
  end

  def self.instructions
    <<~HEREDOC
  
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        To move a piece, look at the files, which are letters a-h, and the ranks, which are 1-8.
        Then, you must type the coordinate of the piece you want to move and its destination.
        For example, I want to move the pawn from "e2" to "e4", thus you must enter "e2e4"
        without spacing.
  
        In summary, the format is source and destination coordinate, leading the file first
        and then the rank, such as "a1a5", "c1f4", "g1f3".
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
    HEREDOC
  end

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
