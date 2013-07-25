require_relative 'piece'
require_relative 'board'

class Game


end




board = Board.new
board.build_board
board.print_board

board.perform_moves!([ [5, 0], [4, 1] ])
board.print_board
board.perform_moves!([ [2, 1], [3, 2] ])
board.print_board
board.perform_moves!([ [3, 2], [5, 0] ])
board.print_board
# board.perform_moves!([ [5, 2], [3, 4] ])
# board.print_board

new_board = board.dup

new_board.print_board






# piece = Piece.new(:white, [4, 3])
# piece.set_king
# p piece.slide_moves
# p piece.jump_moves