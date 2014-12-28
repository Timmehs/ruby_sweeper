class Board

  attr_reader :grid

  def initialize(size, bombs)
    @size = size
    @bomb = bombs
    @grid = create_grid
    set_bombs
  end

  def over?
    if win? || lose?
      return true
    else
      false
    end
  end

  def win?
    @grid.all? do |row|
      row.all? do |tile|
        (tile.revealed && !tile.bomb) || (tile.flagged && tile.bomb)
      end
    end
  end

  def lose?
    @grid.any? do |row|
      row.any? do |tile|
        (tile.revealed && tile.bomb)
      end
    end
  end

  def on_board? pos
    pos.all? { |num| num.between?(0, @size - 1) }
  end

  def []=(pos)
    row, col = pos

    @grid[row][col]
  end

  def [](pos)
    row, col = pos

    @grid[row][col]
  end

  def create_grid
    grid = Array.new(@size) { Array.new(@size) }
    grid.each_with_index do |row, rowidx|
      row.each_with_index do |col, colidx|
        grid[rowidx][colidx] = Tile.new(self, [rowidx, colidx])
      end
    end

    grid
  end

  def set_bombs
    coords = []
    while coords.length < @bomb
      rand_coord = [rand(@size), rand(@size)]
      coords << rand_coord unless coords.include?(rand_coord)
    end

    coords.each { |pos| self[pos].bomb = true}
  end

  def set_count
  end

  def display
    header = "\n    "
    (0..@size - 1).each {|i| header += " #{i + 1}".center(3) }
    puts header
    @grid.each_with_index do |row, row_i|
      row_str = " #{row_i + 1} ".rjust(4)
      row.each do |tile|
        row_str += tile.to_string
      end
      puts row_str
    end
  end
end
