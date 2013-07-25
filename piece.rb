require 'colorize'

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

  def to_s
    @color.to_s[0].capitalize.colorize(@color)
  end

end