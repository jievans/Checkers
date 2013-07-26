require 'colorize'


class Piece

  attr_reader :color, :position

  def position=(position)
    @position = position
    row, col = position
    @king = true if @color == :white && row == 0
    @king = true if @color == :red && row == 7
  end

  def initialize(color, position, king = false)
    @color = color
    @position = position
    @king = king
  end

  def king?
    @king
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

  def to_s
    if @king
      "K".colorize(@color)
    else
      @color.to_s[0].capitalize.colorize(@color)
    end
  end
end