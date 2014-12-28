require './board'
require './tile'
require 'yaml'

class Game
  attr_reader :board


  def initialize(size = 9, difficulty = 9)
    @board = Board.new(size, difficulty)

  end

  def play
    @quit = false

    puts "Welcome to Minesweeper"
    until @board.over? || @quit
      @board.display
      reveal_or_flag(get_move)
    end

    unless @quit
      @board.display
      puts @board.win? ? "You Win!" : "You Lose!"
    end
  end

  def reveal_or_flag(coords)
    choice = ""

    until "rfsq".split("").include?(choice)
      print "[R]eveal, [F]lag, [S]ave or [Q]uit?"
      choice = gets.chomp.downcase
    end

    move(choice, coords)
  end


  def move(choice, coords)
    tile = @board[coords]
    case choice
    when "r"
      if tile.flagged
        puts "Can't reveal flagged tile"
      else
        tile.bomb ? tile.bomb_reveal : tile.reveal
      end
    when "f"
      if tile.revealed
        puts "TILE ALREADY REVEALED"
      else
        tile.flagged = !tile.flagged
      end
    when "s"
      save
    when "q"
      @quit = true
    end
  end



  def get_move
    move = ""

    until valid?(move)
      print "Enter coordinates (row, column):"
      move = gets.chomp
    end

    move.gsub(/\s+/, "").split(",").map(&:to_i)
  end


  def valid?(move)
    return false unless /\d,\s*\d/.match(move)
    move = move.gsub(/\s+/, "").split(",").map(&:to_i)
    @board.on_board?(move)
  end

  def save
    puts "Saving game..."
    game_state = self.to_yaml
    f = File.open('minesweeper-save', "w")
    f.puts game_state
    f.close
    puts "Save successful."
    @quit = true
  end

  def load
    YAML::load(File.open('minesweeper-save').read)
  end

end

if __FILE__ == $PROGRAM_NAME
    puts "<<<<<---- MINESWEEPER ----->>>>>>\n\n"
    puts "Load file (y/n)?"
    if gets.chomp.downcase == 'y'
      Game.new.load.play
    else
      print "Board size: "
      size = gets.chomp.to_i
      print "Number of mines: "
      difficulty = gets.chomp.to_i
      Game.new(size, difficulty).play
    end
end
