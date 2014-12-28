class Tile
  attr_accessor :bomb, :flagged, :revealed

  NEIGHBORS = [ [-1, -1], [-1, 0], [-1, 1], [0, 1],
                [1, 1],   [1, 0],  [1, -1], [0, -1] ]

  def initialize(
      board,
      position,
      bomb = false,
      flagged = false,
      revealed = false)

    @board    = board
    @position = position
    @bomb     = bomb
    @flagged  = flagged
    @revealed = revealed
  end



  def bomb_reveal
    @revealed = true
  end

  def to_string
    if @flagged
      "\e[31m[F]"
    elsif @bomb
      if @board.win?
        "\e[31m:)\e[0m"
      elsif @board.lose?
        "\e[31m :(\e[0m"
      else
        "\e[36m[ ]\e[0m"
      end
    elsif @revealed
      adj_bombs = adjacent_bombs
      adj_bombs > 0 ? "\e[93m #{adj_bombs} \e[0m" : " _ "
    else
      "\e[36m[ ]\e[0m"
    end
  end

  def neighbors
    legal_neighbors = []
    NEIGHBORS.each do |coord|
      row,col = [@position[0] + coord[0],
              @position[1] + coord[1]]
      legal_neighbors << [row, col] if @board.on_board?([row,col])
    end

    legal_neighbors.map { |coords| @board[coords] }
  end

  def adjacent_bombs
    neighbors.count {|tile| tile.bomb }
  end


  def reveal
    return if @revealed || @flagged || @bomb
    @revealed = true

    return if adjacent_bombs > 0
    neighbors.each { |tile| tile.reveal }
  end

end
