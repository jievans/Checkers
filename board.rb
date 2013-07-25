require_relative 'piece'

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
    set_piece(piece, last_pos)
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

    mid_pos = [(first_row + last_row) / 2, (first_col + last_col) / 2 ]
    mid_piece = at_position(mid_pos)

    raise InvalidMoveError, "There is no piece to jump over." if mid_piece.nil?

    if mid_piece.color == piece.color
      raise InvalidMoveError, "You are not allowed to jump over your own piece."
    end

    to_blank(first_pos)
    to_blank(mid_pos)
    set_piece(piece, last_pos)
  end

  def valid_move_seq?(move_sequence)
    new_board = self.dup
    begin
      new_board.perform_moves!(move_sequence)
    rescue InvalidMoveError => message
      puts message
      return false
    end

    return true
  end

  def perform_moves(move_sequence)
    if valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise InvalidMoveError, "You could not perform the moves."
    end
  end

  def dup_moves(move_sequence)
    new_moves = []
    move_sequence.each do |move|
      new_moves << move.dup
    end
    new_moves
  end

  def perform_moves!(move_sequence)
    move_sequence = dup_moves(move_sequence)
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

  def dup
    new_board = Board.new

    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |square, col_idx|
        next if square.nil?
        new_piece = square.class.new(square.color, square.position.dup)
        new_board.set_piece(new_piece, [row_idx, col_idx])
      end
    end

    new_board
  end

  def print_board
    @grid.each_with_index do |row, row_index|
      print "#{8 - row_index} |"
      row.each do |square|
        if square.nil?
          print "___"
        else
          print "_#{square.to_s}_"
        end
        print "|"
      end
      puts "\n"
    end
    puts
    puts "    A   B   C   D   E   F   G   H  "
    puts
  end

  def winner
    reds = 0
    whites = 0

    @grid.each do |row|
      row.each do |square|
        next if square.nil?
        reds += 1 if square.color == :red
        whites += 1 if square.color == :white
      end
    end

    return :red if whites == 0
    return :white if reds == 0
    return false
  end


end