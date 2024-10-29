# module for displaying CLI messages
module Displayable
  def display_board(board)
    file = 'a'
    rank = '8'
    loop_through_board_hash(board, file, rank)

    puts "   +---+---+---+---+---+---+---+---+\n     a   b   c   d   e   f   g   h"
  end

  private

  def loop_through_board_hash(board, file, rank)
    until rank == '0'
      puts '   +---+---+---+---+---+---+---+---+'
      print "#{rank}  "
      until file == 'i'
        piece = board[(file + rank).to_sym][:piece]
        print "| #{piece.nil? ? ' ' : piece.symbol} "
        file = (file.ord + 1).chr
      end
      puts '|'
      file = 'a'
      rank = (rank.to_i - 1).to_s
    end
  end
end
