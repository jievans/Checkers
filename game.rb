class Game



end


class Piece

  def initialize(color, position)
    @color = color
    @position = position
    @king = false
  end

  def slide_moves
    moves = []
    cur_row, cur_col = @position
    drow = @color == :red ? -1 : 1
    [-1, 1].each do |dcol|
      moves << [cur_row + drow, cur_col + dcol]
      moves << [cur_row + drow * -1, cur_col + dcol] if @king
    end
    moves
  end

  def jump_moves
  end

end