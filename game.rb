class Game



end

class InvalidMoveError < StandardError
end

class Board

  def initialize
    @grid = Array.new(8) {Array.new(8)}
  end

  def at_position(position)
    row, col = position
    @grid[row][col]
  end

  def build_board
    @grid[7][0] = Piece.new(:white, [7, 0])
    @grid[7][2] = Piece.new(:white, [7, 2])
    @grid[7][4] = Piece.new(:white, [7, 4])
    @grid[7][6] = Piece.new(:white, [7, 6])

    @grid[5][0] = Piece.new(:white, [5, 0])
    @grid[5][2] = Piece.new(:white, [5, 2])
    @grid[5][4] = Piece.new(:white, [5, 4])
    @grid[5][6] = Piece.new(:white, [5, 6])

    @grid[6][1] = Piece.new(:white, [6, 1])
    @grid[6][3] = Piece.new(:white, [6, 3])
    @grid[6][5] = Piece.new(:white, [6, 5])
    @grid[6][7] = Piece.new(:white, [6, 7])

    @grid[0][1] = Piece.new(:red, [0, 1])
    @grid[0][3] = Piece.new(:red, [0, 3])
    @grid[0][5] = Piece.new(:red, [0, 5])
    @grid[0][7] = Piece.new(:red, [0, 7])

    @grid[2][1] = Piece.new(:red, [2, 1])
    @grid[2][3] = Piece.new(:red, [2, 3])
    @grid[2][5] = Piece.new(:red, [2, 5])
    @grid[2][7] = Piece.new(:red, [2, 7])

    @grid[1][0] = Piece.new(:red, [1, 0])
    @grid[1][2] = Piece.new(:red, [1, 2])
    @grid[1][4] = Piece.new(:red, [1, 4])
    @grid[1][6] = Piece.new(:red, [1, 6])
  end

  def set_piece(piece, position)
    piece.position = position
    row, col = position
    @grid[row][col] = piece
  end

  def to_blank(position)
    row, col = position
    @grid[row][col] = nil
  end

  def self.on_board?(position)
    row, col = position
    row >= 0 && row <= 8 && col >=0 && col <= 8
  end

  def perform_slide(first_pos, last_pos)
    piece = at_position(first_pos)

    unless at_position(last_pos).nil?
      raise InvalidMoveError, "That is not an empty space."
    end
    unless piece.slide_moves.include?(last_pos)
      raise InvalidMoveError, "Your piece is not allowed to slide there."
    end

    to_blank(first_pos)
    set_piece(piece, last_position)
  end

  def perform_jump(first_pos, last_pos)
    piece = at_position(first_pos)

    unless at_position(last_pos).nil?
      raise InvalidMoveError, "That is not an empty space."
    end
    unless piece.jump_moves.include?(last_pos)
      raise InvalidMoveError, "Your piece is not allowed to jump there."
    end

    first_row, first_col = first_pos
    last_row, last_col = last_pos

    mid_pos = [(first_row + last_row) / 2, (first_col + last_col / 2)]
    mid_piece = at_position(mid_pos)

    raise InvalidMoveError, "There is no piece to jump over." if mid_piece.nil?

    if mid_piece.color == piece.color
      raise InvalidMoveError, "You are not allowed to jump over your own piece."
    end

    to_blank(first_pos)
    set_piece(piece, last_position)
  end

  def perform_moves!(move_sequence)
    if at_position(move_sequence.first).nil?
      raise InvalidMoveError, "You haven't selected a piece to start moving."
    end

    until move_sequence.count == 1
      first_pos = move_sequence[0]
      second_pos = move_sequence[1]

      is_jump = (first_pos.first - second_pos.first).abs > 1 ? true: false

      if is_jump
        perform_jump(first_pos, second_pos)
      else
        perform_slide(first_pos, second_pos)
      end

      move_sequence.shift
    end
  end

end




class Piece

  attr_accessor :position
  attr_reader :color

  def initialize(color, position)
    @color = color
    @position = position
    @king = false
  end

  def move_magnitude(magnitude)
    moves = []
    cur_row, cur_col = @position
    drow = @color == :white ? -1 : 1
    drow = drow * magnitude
    [-magnitude, magnitude].each do |dcol|
      moves << [cur_row + drow, cur_col + dcol]
      moves << [cur_row + drow * -1, cur_col + dcol] if @king
    end
    moves.select { |move| Board.on_board?(move) }
  end

  def slide_moves
    move_magnitude(1)
  end

  def set_king
    @king = true
  end

  def jump_moves
    move_magnitude(2)
  end

end



piece = Piece.new(:white, [4, 3])
piece.set_king
p piece.slide_moves
p piece.jump_moves