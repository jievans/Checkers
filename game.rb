require_relative 'piece'
require_relative 'board'

class Game

  def run()
    board = Board.new
    board.build_board()

    puts "Welcome to Checkers!"

    moving_color = :white

    until board.winner
      board.print_board()
      print "#{moving_color.to_s.capitalize} choose your move sequence, "
      puts "separated by commas (e.g., A4, B5) "

      user_input = gets.chomp
      move_sequence = user_input.split(", ").map { |string| translate(string) }

      begin
        board.perform_moves(move_sequence)
      rescue InvalidMoveError => message
        puts message
        next
      end

      moving_color = moving_color == :white ? :red : :white
    end

    winner = board.winner
    puts "#{winner.to_s.capitalize} won the game.  Goodbye!"

  end

  def translate(input_string)
    letter = input_string[0]
    col = letter.capitalize.ord - 65
    row = 8 - input_string[1].to_i

    [row, col]
  end

end


Game.new.run()